import 'dart:async';

import 'package:async/async.dart';
import 'package:extensions/hosting.dart';

import '../../common/http_connections/connection_context.dart';
import '../../common/http_connections/connection_factory.dart';
import '../../common/http_connections_common/end_point.dart';
import '../../common/shared/create_linked_token.dart';
import '../../common/shared/date_time_extensions.dart';
import '../../common/signalr_common/protocol/close_message.dart';
import '../../common/signalr_common/protocol/handshake_protocol.dart';
import '../../common/signalr_common/protocol/handshake_request_message.dart';
import '../../common/signalr_common/protocol/hub_invocation_message.dart';
import '../../common/signalr_common/protocol/hub_message.dart';
import '../../common/signalr_common/protocol/hub_protocol.dart';

import '../../common/signalr_common/protocol/message_type.dart';
import 'hub_connection_builder.dart';
import 'hub_connection_logger_extensions.dart';
import 'hub_connection_state.dart';
import 'internal/invocation_request.dart';
import 'retry_context.dart';
import 'retry_policy.dart';

typedef ClosedCallback = Future<void>? Function(Exception? exception);
typedef ReconnectingCallback = Future<void>? Function(Exception? exception);
typedef ReconnectedCallback = Future<void>? Function(String? connectionId);

/// A connection used to invoke hub methods on a SignalR Server.
///
/// A [HubConnection] should be created using [HubConnectionBuilder].
/// Before hub methods can be invoked the connection must be started
/// using [start]. Clean up a connection using [stop] or [disposeAsync].
class HubConnection implements AsyncDisposable {
  /// The default timeout which specifies how long to wait for a message
  /// before closing the connection.
  ///
  /// Default is 30 seconds.
  static const Duration defaultServerTimeout = Duration(seconds: 30);

  /// The default timeout which specifies how long to wait for the handshake
  /// to respond before closing the connection.
  ///
  /// Default is 15 seconds.
  static const Duration defaultHandshakeTimeout = Duration(seconds: 15);

  /// The default interval that the client will send keep alive messages
  /// to let the server know to not close the connection.
  ///
  /// Default is 15 second interval.
  static const Duration defaultKeepAliveInterval = Duration(seconds: 15);

  final LoggerFactory _loggerFactory;
  final Logger _logger;
  // ConnectionLogScope _logScope;
  final HubProtocol _protocol;
  final ServiceProvider _serviceProvider;
  final ConnectionFactory _connectionFactory;
  RetryPolicy? _reconnectPolicy;
  final EndPoint _endPoint;

  // Holds all mutable state other than user-defined handlers and settable
  // properties.
  late final ReconnectingConnectionState _state;

  bool _disposed = false;

  /// Occurs when the connection is closed. The connection could be closed
  /// due to an error or due to either the server or client intentionally.
  ClosedCallback? closed;

  /// Occurs when the [HubConnection] starts reconnecting after losing its
  /// underlying connection.
  ReconnectingCallback? reconnecting;

  /// Occurs when the [HubConnection] successfully reconnects after losing
  /// its underlying connection.
  ReconnectedCallback? reconnected;

  /// Gets or sets the server timeout interval for the connection.
  ///
  /// /// The client times out if it hasn't heard from the server for
  /// `this` long.
  Duration serverTimeout = defaultServerTimeout;

  /// Gets or sets the interval at which the client sends ping messages.
  ///
  /// Sending any message resets the timer to the start of the interval.
  Duration keepAliveInterval = defaultKeepAliveInterval;

  /// Gets or sets the timeout for the initial handshake.
  Duration handshakeTimeout = defaultHandshakeTimeout;

  /// Gets the connection's current Id. This value will be cleared when
  /// the connection is stopped and will have a new value every time the
  /// connection is (re)established.
  String? get connectionId =>
      _state.currentConnectionStateUnsynchronized?.connection.connectionId;

  /// Indicates the state of the [HubConnection] to the server.
  HubConnectionState get state => _state.overallState;

  /// Initializes a new instance of the [HubConnection] class.
  HubConnection({
    required ConnectionFactory connectionFactory,
    required HubProtocol protocol,
    required EndPoint endPoint,
    required ServiceProvider serviceProvider,
    LoggerFactory loggerFactory = const NullLoggerFactory(),
  })  : _connectionFactory = connectionFactory,
        _protocol = protocol,
        _endPoint = endPoint,
        _serviceProvider = serviceProvider,
        _loggerFactory = loggerFactory,
        _logger = loggerFactory.createLogger('HubConnection') {
    _state = ReconnectingConnectionState(_logger);
  }

  /// Starts a connection to the server.
  Future<void> start([CancellationToken? cancellationToken]) async {
    _checkDisposed();
    await _startInner(cancellationToken);
  }

  Future<void> _startInner([CancellationToken? cancellationToken]) async {
    cancellationToken ??= CancellationToken();

    try {
      if (!_state.tryChangeState(
        HubConnectionState.disconnected,
        HubConnectionState.connecting,
      )) {
        throw Exception(
          'The HubConnection cannot be started if it is not in the'
          ' HubConnectionState.disconnected state.',
        );
      }

      // The StopCts is canceled at the start of StopAsync should be reset
      // every time the connection finishes stopping. If this token is
      // currently canceled, it means that StartAsync was called while
      //Stop was still running.
      if (_state.stopCts.token.isCancellationRequested) {
        throw Exception(
            'The HubConnection cannot be started while stop is running.');
      }

      final linkedToken = createLinkedToken(
        cancellationToken,
        _state.stopCts.token,
      );
      await _startCore(linkedToken);

      _state.changeState(
        HubConnectionState.connecting,
        HubConnectionState.connected,
      );
    } on Exception {
      if (_state.tryChangeState(
        HubConnectionState.connecting,
        HubConnectionState.disconnected,
      )) {
        _state.stopCts = CancellationTokenSource();
      }

      rethrow;
    }
  }

  Future<void> stop(CancellationToken? cancellationToken) async {
    _checkDisposed();
    await stopCore(disposing: false);
  }

  /// Disposes the [HubConnection].
  @override
  Future<void> disposeAsync() async {
    if (!_disposed) {
      await stopCore(disposing: true);
    }
  }

  Future<void> _startCore(CancellationToken cancellationToken) async {
    cancellationToken.throwIfCancellationRequested();

    _checkDisposed();

    _logger.starting();

    // Start the connection
    final connection = await _connectionFactory.connect(
      _endPoint,
      cancellationToken,
    );

    final startingConnectionState = ConnectionState(connection, this);

    startingConnectionState.connection.transport?.input.listen((data) {
      final messages = _protocol.parseMessage(data);
      for (var message in messages) {
        print(message.toString());
        //_processMessage(message, connectionState);
      }
    });

    // From here on, if an error occurs we need to shut down the connection
    // because we still own it.
    try {
      _logger.hubProtocol(_protocol.name, _protocol.version);
      handshake(startingConnectionState, cancellationToken);
    } on Exception catch (ex) {
      _logger.errorStartingConnection(ex);

      // Can't have any invocations to cancel, we're in the lock.
      //await close(startingConnectionState.connection);
      rethrow;
    }

    _state.currentConnectionStateUnsynchronized = startingConnectionState;

    startingConnectionState._receiveFuture =
        receiveLoop(startingConnectionState);

    _logger.started();
  }

  Future<void> handleConnectionClose(ConnectionState connectionState) async {
    _state.currentConnectionStateUnsynchronized = null;

    //await close(connectionState.connection);

    connectionState
        .cancelOutstandingInvocations(connectionState.closeException);

    if (connectionState.stopping || _reconnectPolicy == null) {
      if (connectionState.closeException != null) {
        _logger.shutdownWithError(connectionState.closeException!);
      } else {
        _logger.shutdownConnection();
      }

      _state.changeState(
        HubConnectionState.connected,
        HubConnectionState.disconnected,
      );
      _completeClose(connectionState.closeException);
    } else {
      _state.reconnectFuture = _reconnect(connectionState.closeException);
    }
  }

  void _completeClose(Exception? exception) {
    _state.stopCts = CancellationTokenSource();
    _runCloseEvent(exception);
  }

  void _runCloseEvent(Exception? closeException) {}

  Future<void> _reconnect(Exception? closeException) async {
    var previousReconnectAttempts = 0;
    var reconnectStartTime = DateTime.now().toUtc();
    var retryReason = closeException;
    var nextRetryDelay = _getNextRetryDelay(
      previousReconnectAttempts,
      Duration.zero,
      retryReason,
    );

    if (nextRetryDelay == null) {
      _logger.firstReconnectRetryDelayNull();

      _state.changeState(
        HubConnectionState.connected,
        HubConnectionState.disconnected,
      );

      _completeClose(closeException);
      return;
    }

    _state.changeState(
      HubConnectionState.connected,
      HubConnectionState.reconnecting,
    );

    if (closeException != null) {
      _logger.reconnectingWithError(closeException);
    } else {
      _logger.reconnecting();
    }

    //_runReconnectingEvent(closeException);
    while (nextRetryDelay != null) {
      _logger.awaitingReconnectRetryDelay(
        previousReconnectAttempts + 1,
        nextRetryDelay,
      );

      var retryDelay = CancelableOperation.fromFuture(
        Future<void>.delayed(nextRetryDelay),
        onCancel: () {
          _logger.reconnectingStoppedDuringRetryDelay();

          _state.changeState(
            HubConnectionState.reconnecting,
            HubConnectionState.disconnected,
          );

          _completeClose(
            Exception(
              'Connection stopped during reconnect delay. Done reconnecting.',
            ),
          );

          return;
        },
      );

      _state.stopCts.token.register((state) {
        retryDelay.cancel();
      });

      await retryDelay.value;

      try {
        await _startCore(_state.stopCts.token);

        _logger.reconnected(
          previousReconnectAttempts,
          DateTime.now().toUtc().difference(reconnectStartTime),
        );

        _state.changeState(
          HubConnectionState.reconnecting,
          HubConnectionState.connected,
        );
      } on Exception catch (ex) {
        retryReason = ex;

        _logger.reconnectAttemptFailed(ex);

        if (_state.stopCts.isCancellationRequested) {
          _logger.reconnectingStoppedDuringReconnectAttempt();

          _state.changeState(
            HubConnectionState.reconnecting,
            HubConnectionState.disconnected,
          );

          _completeClose(
            Exception(
              'Connection stopped during reconnect attempt. Done reconnecting.',
            ),
          );

          return;
        }

        previousReconnectAttempts++;
      }

      nextRetryDelay = _getNextRetryDelay(
        previousReconnectAttempts,
        DateTime.now().toUtc().difference(reconnectStartTime),
        retryReason,
      );
    }

    var elapsedTime = DateTime.now().toUtc().difference(reconnectStartTime);
    _logger.reconnectAttemptsExhausted(
      previousReconnectAttempts,
      elapsedTime,
    );

    _state.changeState(
      HubConnectionState.reconnecting,
      HubConnectionState.disconnected,
    );

    var message =
        'Reconnect retries have been exhausted after $previousReconnectAttempts'
        ' failed attempts and $elapsedTime elapsed. Disconnecting.';

    _completeClose(Exception(message));
  }

  Duration? _getNextRetryDelay(
    int previousRetryCount,
    Duration elapsedTime,
    Exception? retryReason,
  ) {
    try {
      return _reconnectPolicy!.nextRetryDelay(
        RetryContext(
          previousRetryCount: previousRetryCount,
          elapsedTime: elapsedTime,
          retryReason: retryReason,
        ),
      );
    } on Exception catch (ex) {
      _logger.errorDuringNextRetryDelay(ex);
      return null;
    }
  }

  void runReconnectedEvent() {
    var reconnected = this.reconnected;
    try {
      if (reconnected != null) {
        reconnected.call(connectionId);
      }
    } on Exception catch (ex) {
      _logger.errorDuringReconnectedEvent(ex);
    }
  }

  Future<void> receiveLoop(ConnectionState connectionState) {
    _logger.receiveLoopStarting();

    var timer = RestartableTimer(const Duration(seconds: 1), () {});

    // connectionState.connection.transport?.stream.listen((data) {
    //   final messages = _protocol.parseMessage(data);
    //   for (var message in messages) {
    //     print(message.toString());
    //     //_processMessage(message, connectionState);
    //   }
    // });

    return Future.value();
  }

/*
  Future<CloseMessage?> _processMessage(
    HubMessage message,
    ConnectionState connectionState,
  ) {
    _logger.resettingKeepAliveTimer();
    connectionState.resetTimeout();

    InvocationRequest? irq;
    switch (message.type) {
      case MessageType.invocation:
        break;
      case MessageType.streamItem:
      case MessageType.completion:
        var invocationMessage = message as HubInvocationMessage;
        break;
      case MessageType.streamInvocation:
        break;
      case MessageType.cancelInvocation:
        break;
      case MessageType.ping:
        break;
      case MessageType.close:

      default:
    }
  }
*/
  Future<void> stopCore({bool? disposing}) async {
    _state.stopCts.cancel();

    var reconnectFuture = _state.reconnectFuture;

    ConnectionState? connectionState;

    if (disposing! && _disposed) {
      return;
    }

    _checkDisposed();
    connectionState = _state.currentConnectionStateUnsynchronized;

    if (connectionState != null) {
      connectionState.stopping = true;
    } else {
      _state.stopCts = CancellationTokenSource();
    }

    if (disposing) {
      _disposed = true;
      if (_serviceProvider is AsyncDisposable) {
        await (_serviceProvider as AsyncDisposable).disposeAsync();
      } else {
        (_serviceProvider as Disposable).dispose();
      }
    }

    if (connectionState != null) {
      await connectionState.stop();
    }
  }

  void handshake(
    ConnectionState startingConnectionState,
    CancellationToken cancellationToken,
  ) {
    // Send the Handshake request
    _logger.sendingHubHandshake();

    final handshakeRequest = HandshakeRequestMessage(
      protocol: _protocol.name,
      version: _protocol.version,
    );

    final result = writeRequestMessage(handshakeRequest);
    startingConnectionState.connection.transport!.output.add(result);
  }

  /// Registers a handler that will be invoked when the hub method with
  /// the specified method name is invoked. Returns value returned by
  /// handler to server if the server requests a result.
  Disposable on(
    String methodName,
    List<Type> parameterTypes,
    Future<Object?> Function(List<Object?>, Object) handler,
    Object state,
  ) {
    throw UnimplementedError();
  }

  /// Removes all handlers associated with the method with the specified
  /// method name.
  void remove(String methodName) {}

  void _checkDisposed() {
    if (_disposed) {
      throw Exception('Object disposed HubConnection');
    }
  }

  Future<void> sendHubMessage(
    ConnectionState connectionState,
    HubMessage hubMessage,
    CancellationToken? cancellationToken,
  ) async {
    var message = _protocol.writeMessage(hubMessage);

    _logger.sendingMessage(hubMessage);
    connectionState.connection.transport!.output.add(message);
    _logger.messageSent(hubMessage);

    // We've sent a message, so don't ping for a while
    connectionState.resetSendPing();
  }
}

class InvocationHandler {}

class InvocationHandlerList {
  final List<InvocationHandler> _invocationHandlers;

  InvocationHandlerList(InvocationHandler handler)
      : _invocationHandlers = <InvocationHandler>[handler];

  List<InvocationHandler> getHandlers() => _invocationHandlers;
}

class ReconnectingConnectionState {
  final Logger _logger;
  HubConnectionState _overallState;

  ReconnectingConnectionState(this._logger)
      : _overallState = HubConnectionState.disconnected;

  ConnectionState? currentConnectionStateUnsynchronized;

  HubConnectionState get overallState => _overallState;

  CancellationTokenSource stopCts = CancellationTokenSource();

  Future<void> reconnectFuture = Future.value();

  void changeState(
    HubConnectionState expectedState,
    HubConnectionState newState,
  ) {
    if (!tryChangeState(expectedState, newState)) {
      _logger.stateTransitionFailed(expectedState, newState, overallState);
      throw Exception(
        'The HubConnection failed to transition from the \'$expectedState\''
        ' state to the \'$newState\' state because it was actually in the'
        ' \'$overallState\' state.',
      );
    }
  }

  bool tryChangeState(
    HubConnectionState expectedState,
    HubConnectionState newState,
  ) {
    _logger.attemptingStateTransition(expectedState, newState);

    if (overallState != expectedState) {
      return false;
    }

    _overallState = newState;
    return true;
  }

  bool isConnectionActive() =>
      (currentConnectionStateUnsynchronized != null) &&
      !currentConnectionStateUnsynchronized!.stopping;
}

class ConnectionState {
  final HubConnection _hubConnection;
  final Logger _logger;
  // final bool _hasInherentKeepAlive;

  final Map<String, InvocationRequest> _pendingCalls =
      <String, InvocationRequest>{};
  Completer<Object?>? _stopCompleter; // _stopTcs
  int _nextInvocationId;
  int _nextActivationServerTimeout;
  int _nextActivationSendPing;

  final ConnectionContext _connection;
  Future<void>? _receiveFuture;
  Exception? closeException;
  CancellationToken? uploadStreamToken;

  Future<void>? invocationMessageReceiveFuture;

  ConnectionState(ConnectionContext connection, HubConnection hubConnection)
      : _connection = connection,
        _hubConnection = hubConnection,
        _logger = hubConnection._logger,
        _nextInvocationId = 0,
        _nextActivationServerTimeout = 0,
        _nextActivationSendPing = 0,
        stopping = false;

  ConnectionContext get connection => _connection;

  bool stopping;

  String getNextId() => (_nextInvocationId++).toString();

  void addInvocation(InvocationRequest irq) {
    if (_pendingCalls.containsKey(irq.invocationId)) {
      _logger.invocationAlreadyInUse(irq.invocationId);
      throw Exception(
          'Invocation ID \'${irq.invocationId}\' is already in use.');
    } else {
      _pendingCalls[irq.invocationId] = irq;
    }
  }

  InvocationRequest? tryGetInvocation(String invocationId) {
    if (_pendingCalls.containsKey(invocationId)) {
      return _pendingCalls[invocationId];
    }

    return null;
  }

  InvocationRequest? tryRemoveInvocation(String invocationId) {
    if (_pendingCalls.containsKey(invocationId)) {
      final invocationRequest = _pendingCalls[invocationId];
      _pendingCalls.remove(invocationId);
      return invocationRequest;
    }

    return null;
  }

  void cancelOutstandingInvocations(Exception? exception) {
    _logger.cancelingOutstandingInvocations();

    for (var outstandingCall in _pendingCalls.values) {
      _logger.removingInvocation(outstandingCall.invocationId);
      if (exception != null) {
        outstandingCall.fail(exception);
      }
      outstandingCall.dispose();
    }
    _pendingCalls.clear();
  }

  Future<void> stop() {
    if (_stopCompleter != null) {
      return _stopCompleter!.future;
    } else {
      _stopCompleter = Completer<Object?>();
      return _stopCore();
    }
  }

  Future<void> _stopCore() async {
    _logger
      ..stopping()
      ..terminatingReceiveLoop();

    await (_receiveFuture ?? Future.value());

    _logger.stopped();
    _stopCompleter!.complete(null);
  }

  void resetSendPing() {
    _nextActivationSendPing =
        (DateTime.now().toUtc().add(_hubConnection.serverTimeout)).ticks;
  }

  void resetTimeout() {
    _nextActivationServerTimeout =
        (DateTime.now().toUtc().add(_hubConnection.serverTimeout)).ticks;
  }

  Future<void> _runTimerActions() {
    // if (_hasInherentKeepAlive) {
    //return;
    // }

    if (DateTime.now().toUtc().ticks > _nextActivationServerTimeout) {
      //onServerTimeout();
    }

    if (DateTime.now().toUtc().ticks > _nextActivationSendPing) {}

    return Future.value();
  }
}
