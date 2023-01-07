import 'dart:async';
import 'dart:math';

import 'package:extensions/logging.dart';
import 'package:extensions/primitives.dart';
import 'package:quiver/strings.dart';
import 'package:stream_channel/stream_channel.dart';

import 'package:signalr/signalr.dart';
import 'package:signalr/src/common/signalr_common/protocol/completion_message.dart';

import '../hub_connection.dart';

abstract class InvocationRequest implements Disposable {
  // CancellationTokenRegistration _cancellationTokenRegistration;
  Logger _logger;
  Type _resultType;
  CancellationToken _cancellationToken;
  String _invocationId;
  HubConnection _hubConnection;

  InvocationRequest({
    required CancellationToken cancellationToken,
    required Type resultType,
    required String invocationId,
    required Logger logger,
    required HubConnection hubConnection,
  })  : _cancellationToken = cancellationToken,
        _resultType = resultType,
        _invocationId = invocationId,
        _logger = logger,
        _hubConnection = hubConnection {
    _logger.invocationCreated(invocationId);
  }

  factory InvocationRequest.invoke(
    CancellationToken cancellationToken,
    Type resultType,
    String invocationId,
    LoggerFactory loggerFactory,
    HubConnection hubConnection,
  ) {
    return NonStreaming(
      cancellationToken: cancellationToken,
      resultType: resultType,
      invocationId: invocationId,
      loggerFactory: loggerFactory,
      hubConnection: hubConnection,
    );
  }

  factory InvocationRequest.stream(
    CancellationToken cancellationToken,
    Type resultType,
    String invocationId,
    LoggerFactory loggerFactory,
    HubConnection hubConnection,
  ) {
    return Streaming(
      cancellationToken: cancellationToken,
      resultType: resultType,
      invocationId: invocationId,
      loggerFactory: loggerFactory,
      hubConnection: hubConnection,
    );
  }

  void fail(Exception exception);
  void complete(CompletionMessage message);
  Future<bool> streamItem(Object? item);
  void _cancel();

  @override
  void dispose() {
    _logger.invocationDisposed(_invocationId);

    // Just in case it hasn't already been completed
    _cancel();

    //_cancellationTokenRegistration.Dispose();
  }
}

class Streaming extends InvocationRequest {
  StreamChannelController<Object?> _channel = StreamChannelController();

  Streaming({
    required super.cancellationToken,
    required super.resultType,
    required super.invocationId,
    required LoggerFactory loggerFactory,
    required super.hubConnection,
  }) : super(
          logger: loggerFactory.createLogger('Streaming'),
        );

  Stream<Object?> get result => _channel.local.stream;

  @override
  void complete(CompletionMessage message) {
    _logger.invocationCompleted(_invocationId);
    if (message.result != null) {
      _logger.receivedUnexpectedComplete(_invocationId);
      _channel.local.sink.close();
      throw Exception(
        'Server provided a result in a completion response to a streamed invocation.',
      );
    }

    if (isNotBlank(message.error)) {
      fail(HubException(message.error));
      return;
    }
  }

  @override
  void fail(Exception exception) {
    _logger.invocationFailed(_invocationId);
    _channel.local.sink.close();
  }

  @override
  Future<bool> streamItem(Object? item) {
    _channel.local.sink.add(item);

    return Future.value(true);
  }

  @override
  void _cancel() {
    _channel.local.sink.close();
  }
}

class NonStreaming extends InvocationRequest {
  final Completer<Object?> _completer = Completer<Object?>();

  NonStreaming({
    required super.cancellationToken,
    required super.resultType,
    required super.invocationId,
    required LoggerFactory loggerFactory,
    required super.hubConnection,
  }) : super(logger: loggerFactory.createLogger('NonStreaming'));

  Future<Object?> get result => _completer.future;

  @override
  void complete(CompletionMessage message) {
    if (isNotBlank(message.error)) {
      fail(HubException(message.error));
      return;
    }

    _logger.invocationCompleted(_invocationId);
    _completer.complete(message.result);
  }

  @override
  void fail(Exception exception) {
    _logger.invocationFailed(_invocationId);
    _completer.completeError(exception);
  }

  @override
  Future<bool> streamItem(Object? item) {
    _logger.streamItemOnNonStreamInvocation(_invocationId);
    _completer.completeError(Exception(
        'Streaming hub methods must be invoked with the \'HubConnectionExtensions.streamAsChannel\' method.'));

    // We \'delivered\' the stream item successfully as far as the caller cares
    return Future.value(true);
  }

  @override
  void _cancel() {
    _completer.complete();
  }
}

extension InvocationRequestLoggerExtensions on Logger {
  // Category: Streaming and NonStreaming

  void invocationCreated(String invocationId) {
    logTrace(
      'Invocation $invocationId created.',
      eventId: EventId(1, 'InvocationCreated'),
    );
  }

  void invocationDisposed(String invocationId) {
    logTrace(
      'Invocation $invocationId disposed.',
      eventId: EventId(2, 'InvocationDisposed'),
    );
  }

  void invocationCompleted(String invocationId) {
    logTrace(
      'Invocation $invocationId marked as completed.',
      eventId: EventId(3, 'InvocationCompleted'),
    );
  }

  void invocationFailed(String invocationId) {
    logTrace(
      'Invocation $invocationId marked as failed.',
      eventId: EventId(4, 'InvocationFailed'),
    );
  }

  // Category: Streaming

  void errorWritingStreamItem(
    String invocationId,
    Exception exception,
  ) {
    logError(
      'Invocation $invocationId caused an error trying to write a stream item.',
      eventId: EventId(5, 'ErrorWritingStreamItem'),
      exception: exception,
    );
  }

  void receivedUnexpectedComplete(String invocationId) {
    logError(
      'Invocation $invocationId received a completion result, but was invoked as a streaming invocation.',
      eventId: EventId(6, 'ReceivedUnexpectedComplete'),
    );
  }

  // Category: NonStreaming

  void streamItemOnNonStreamInvocation(String invocationId) {
    logError(
      'Invocation $invocationId received stream item but was invoked as a non-streamed invocation.',
      eventId: EventId(7, 'StreamItemOnNonStreamInvocation'),
    );
  }
}
