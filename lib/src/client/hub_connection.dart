import 'package:extensions/hosting.dart';
import 'package:signalr/signalr.dart';
import 'package:signalr/src/client/http/http_connection.dart';
import 'package:signalr/src/client/hub_connection_logger_extensions.dart';
import 'package:signalr/src/client/hub_connection_state.dart';

import '../common/http/connections/connection_factory.dart';
import '../common/http/end_point.dart';
import '../common/protocol/hub_protocol.dart';

typedef ClosedCallback = void Function(Exception? exception);
typedef ReconnectingCallback = void Function(Exception? exception);
typedef ReconnectedCallback = void Function(String? connectionId);

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
  static const Duration defaultServerTimeout = const Duration(seconds: 30);

  /// The default timeout which specifies how long to wait for the handshake
  /// to respond before closing the connection.
  ///
  /// Default is 15 seconds.
  static const Duration defaultHandshakeTimeout = const Duration(seconds: 15);

  /// The default interval that the client will send keep alive messages
  /// to let the server know to not close the connection.
  ///
  /// Default is 15 second interval.
  static const Duration defaultKeepAliveInterval = const Duration(seconds: 15);

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
    try {
      if (!_state.tryChangeState(
          HubConnectionState.disconnected, HubConnectionState.connecting)) {
        throw Exception(
            'The HubConnection cannot be started if it is not in the HubConnectionState.disconnected state.');
      }

      //if (_state.stopCts.token.isCancellationRequested) {
      //  throw Exception('The HubConnection cannot be started while stop is running.');
      //}

      //final linkedToken = createLinkedToken(cancellationToken, _state.stopCts.token);
      //await _startCore(linkedToken);

      _state.changeState(
        HubConnectionState.connecting,
        HubConnectionState.connected,
      );
    } on Exception {
      if (_state.tryChangeState(
          HubConnectionState.connecting, HubConnectionState.disconnected)) {
        //_state.stopCts = CancellationTokenSource();
      }

      rethrow;
    }
  }

  Future<void> _startCore(CancellationToken cancellationToken) {
    cancellationToken.throwIfCancellationRequested();

    _checkDisposed();

    _logger.starting();

    throw UnimplementedError();
  }

  Future<void> stop(CancellationToken cancellationToken) {
    throw UnimplementedError();
  }

  @override
  Future<void> disposeAsync() {
    throw UnimplementedError();
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
}

class ReconnectingConnectionState {
  final Logger _logger;
  HubConnectionState _overallState;

  ReconnectingConnectionState(this._logger)
      : _overallState = HubConnectionState.disconnected;

  HubConnectionState get overallState => _overallState;

  //CancellationTokenSource stopCts = CancellationTokenSource();

  Future<void> reconnectTask = Future.value();

  void changeState(
    HubConnectionState expectedState,
    HubConnectionState newState,
  ) {
    if (!tryChangeState(expectedState, newState)) {
      // _logger.stateTransitionFailed(expectedState, newState, overallState);
      throw Exception(
          'The HubConnection failed to transition from the \'$expectedState\' state to the \'$newState\' state because it was actually in the \'$overallState\' state.');
    }
  }

  bool tryChangeState(
    HubConnectionState expectedState,
    HubConnectionState newState,
  ) {
    // _logger.attemptingStateTransition(expectedState, newState);

    if (overallState != expectedState) {
      return false;
    }

    _overallState = newState;
    return true;
  }
}
