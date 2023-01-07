import 'package:extensions/logging.dart';

import '../../common/signalr_common/protocol/hub_invocation_message.dart';
import '../../common/signalr_common/protocol/hub_message.dart';

import 'hub_connection_state.dart';

extension HubConnectionLoggerExtensions on Logger {
  void preparingNonBlockingInvocation(
    String target,
    int argumentCount,
  ) {
    logTrace(
      'Preparing non-blocking invocation of \'$target\', with $argumentCount argument(s).',
      eventId: EventId(1, 'PreparingNonBlockingInvocation'),
    );
  }

  void preparingBlockingInvocation(
    String invocationId,
    String target,
    String returnType,
    int argumentCount,
  ) {
    logTrace(
      'Preparing blocking invocation \'$invocationId\' of \'$target\', with return type \'$returnType\' and $argumentCount argument(s).',
      eventId: EventId(2, 'PreparingBlockingInvocation'),
    );
  }

  void registeringInvocation(
    String invocationId,
  ) {
    logDebug(
      'Registering Invocation ID \'$invocationId\' for tracking.',
      eventId: EventId(3, 'RegisteringInvocation'),
    );
  }

  void issuingInvocation(
    String invocationId,
    String returnType,
    String methodName,
    List<Object?>? args,
  ) {
    final argsList = args == null
        ? ''
        : args.map((a) => a?.runtimeType.toString()).join(', ');
    logTrace(
      'Issuing Invocation \'$invocationId\': $returnType $methodName($argsList).',
      eventId: EventId(4, 'IssuingInvocation'),
    );
  }

  void sendingMessage(HubMessage message) {
    if (isEnabled(LogLevel.debug)) {
      if (message is HubInvocationMessage) {
        _sendingMessage(
          message.runtimeType.toString(),
          message.invocationId,
        );
      } else {
        _sendingMessageGeneric(message.runtimeType.toString());
      }
    }
  }

  void _sendingMessage(
    String messageType,
    String? invocationId,
  ) {
    logDebug(
      'Sending $messageType message \'$invocationId\'.',
      eventId: EventId(5, 'SendingMessage'),
    );
  }

  void _sendingMessageGeneric(String messageType) {
    logDebug(
      'Sending $messageType message.',
      eventId: EventId(59, 'SendingMessageGeneric'),
    );
  }

  void messageSent(HubMessage message) {
    if (isEnabled(LogLevel.debug)) {
      if (message is HubInvocationMessage) {
        _messageSent(
          message.runtimeType.toString(),
          message.invocationId,
        );
      } else {
        _messageSentGeneric(message.runtimeType.toString());
      }
    }
  }

  void _messageSent(String messageType, String? invocationId) {
    logDebug(
      'Sending $messageType message \'$invocationId\' completed.',
      eventId: EventId(6, 'MessageSent'),
    );
  }

  void _messageSentGeneric(String messageType) {
    logDebug(
      'Sending $messageType message completed.',
      eventId: EventId(60, 'MessageSentGeneric'),
    );
  }

  void failedToSendInvocation(String invocationId, Exception exception) {
    logError(
      'Sending Invocation \'$invocationId\' failed.',
      exception: exception,
      eventId: EventId(7, 'FailedToSendInvocation'),
    );
  }

  void receivedInvocation(
    String? invocationId,
    String methodName,
    List<Object?>? args,
  ) {
    if (isEnabled(LogLevel.trace)) {
      final argsList = args == null
          ? <Object>[]
          : args.map((e) => e?.runtimeType.toString() ?? '(null)').join(', ');
      logTrace(
        'Received Invocation \'$invocationId\': $methodName($argsList).',
        eventId: EventId(8, 'ReceivedInvocation'),
      );
    }
  }

  void droppedCompletionMessage(String invocationId) {
    logWarning(
      'Dropped unsolicited Completion message for invocation \'$invocationId\'.',
      eventId: EventId(9, 'DroppedCompletionMessage'),
    );
  }

  void droppedStreamMessage(String invocationId) {
    logWarning(
      'Dropped unsolicited StreamItem message for invocation \'$invocationId\'.',
      eventId: EventId(10, 'DroppedStreamMessage'),
    );
  }

  void shutdownConnection() {
    logTrace(
      'Shutting down connection.',
      eventId: EventId(11, 'ShutdownConnection'),
    );
  }

  void shutdownWithError() {
    final message = 'Connection is shutting down due to an error.';
    logError(
      message,
      exception: Exception(message),
      eventId: EventId(12, 'ShutdownWithError'),
    );
  }

  void removingInvocation(String invocationId) {
    logTrace(
      'Removing pending invocation $invocationId.',
      eventId: EventId(13, 'RemovingInvocation'),
    );
  }

  void missingHandler(String target) {
    logWarning(
      'Failed to find handler for \'$target\' method.',
      eventId: EventId(14, 'MissingHandler'),
    );
  }

  void receivedStreamItem(String invocationId) {
    logTrace(
      'Received StreamItem for Invocation $invocationId.',
      eventId: EventId(15, 'ReceivedStreamItem'),
    );
  }

  void cancelingStreamItem(String invocationId) {
    logTrace(
      'Canceling dispatch of StreamItem message for Invocation $invocationId. The invocation was canceled.',
      eventId: EventId(16, 'CancelingStreamItem'),
    );
  }

  void receivedStreamItemAfterClose(String invocationId) {
    logWarning(
      'Invocation {InvocationId} received stream item after channel was closed.',
      eventId: EventId(17, 'ReceivedStreamItemAfterClose'),
    );
  }

  void receivedInvocationCompletion(String invocationId) {
    logTrace(
      'Received Completion for Invocation $invocationId.',
      eventId: EventId(18, 'ReceivedInvocationCompletion'),
    );
  }

  void cancelingInvocationCompletion(String invocationId) {
    logTrace(
      'Canceling dispatch of Completion message for Invocation $invocationId. The invocation was canceled.',
      eventId: EventId(19, 'CancelingInvocationCompletion'),
    );
  }

  void stopped() {
    logDebug(
      'HubConnection stopped.',
      eventId: EventId(21, 'Stopped'),
    );
  }

  void invocationAlreadyInUse(String invocationId) {
    logCritical(
      'Invocation ID \'$invocationId\' is already in use.',
      eventId: EventId(22, 'InvocationAlreadyInUse'),
    );
  }

  void receivedUnexpectedResponse(String invocationId) {
    logError(
      'Unsolicited response received for invocation \'$invocationId\'.',
      eventId: EventId(23, 'ReceivedUnexpectedResponse'),
      exception: Exception(), // TODO: Logger should enforce the exception req.
    );
  }

  void hubProtocol(String protocol, int version) {
    logInformation(
      'Using HubProtocol \'$protocol v$version\'.',
      eventId: EventId(24, 'HubProtocol'),
    );
  }

  void preparingStreamingInvocation(
    String invocationId,
    String target,
    String returnType,
    int argumentCount,
  ) {
    logTrace(
      '''Preparing streaming invocation \'$invocationId\' of \'$target\', with return type \'$returnType\' and $argumentCount} argument(s).''',
      eventId: EventId(25, 'PreparingStreamingInvocation'),
    );
  }

  void resettingKeepAliveTimer() {
    logTrace(
      'Resetting keep-alive timer, received a message from the server.',
      eventId: EventId(26, 'ResettingKeepAliveTimer'),
    );
  }

  void errorDuringClosedEvent(Exception exception) {
    logError(
      'An exception was thrown in the handler for the Closed event.',
      eventId: EventId(27, 'ErrorDuringClosedEvent'),
      exception: exception,
    );
  }

  void sendingHubHandshake() {
    logDebug(
      'Sending Hub Handshake.',
      eventId: EventId(28, 'SendingHubHandshake'),
    );
  }

  void receivedPing() {
    logTrace(
      'Received a ping message.',
      eventId: EventId(31, 'ReceivedPing'),
    );
  }

  void errorInvokingClientSideMethod(String methodName, Exception exception) {
    logError(
      'Invoking client side method \'$methodName\' failed.',
      eventId: EventId(34, 'ErrorInvokingClientSideMethod'),
      exception: exception,
    );
  }

  void errorReceivingHandshakeResponse(Exception exception) {
    logError(
      'The underlying connection closed while processing the handshake response. See exception for details.',
      eventId: EventId(35, 'ErrorReceivingHandshakeResponse'),
      exception: exception,
    );
  }

  void handshakeServerError(String error) {
    logError(
      'Server returned handshake error: $error',
      eventId: EventId(36, 'HandshakeServerError'),
      exception: Exception(),
    );
  }

  void receivedClose(String error) {
    logDebug(
      'Received close message.',
      eventId: EventId(37, 'ReceivedClose'),
    );
  }

  void receivedCloseWithError(String error) {
    logError(
      'Received close message with an error: $error',
      eventId: EventId(38, 'ReceivedCloseWithError'),
      exception: Exception(),
    );
  }

  void handshakeComplete() {
    logDebug(
      'Handshake with server complete.',
      eventId: EventId(39, 'HandshakeComplete'),
    );
  }

  void registeringHandler(String methodName) {
    logDebug(
      'Registering handler for client method \'$methodName\'.',
      eventId: EventId(40, 'RegisteringHandler'),
    );
  }

  void removingHandlers(String methodName) {
    logDebug(
      'Removing handlers for client method \'$methodName\'.',
      eventId: EventId(58, 'RemovingHandlers'),
    );
  }

  void starting() {
    logDebug(
      'Starting HubConnection.',
      eventId: EventId(41, 'Starting'),
    );
  }

  void errorStartingConnection(Exception exception) {
    logError(
      'Error starting connection.',
      eventId: EventId(43, 'ErrorStartingConnection'),
      exception: exception,
    );
  }

  void started() {
    logInformation(
      'HubConnection started.',
      eventId: EventId(44, 'Started'),
    );
  }

  void sendingCancellation(String invocationId) {
    logDebug(
      'Sending Cancellation for Invocation \'$invocationId\'.',
      eventId: EventId(45, 'SendingCancellation'),
    );
  }

  void cancelingOutstandingInvocations() {
    logDebug(
      'Canceling all outstanding invocations.',
      eventId: EventId(46, 'CancelingOutstandingInvocations'),
    );
  }

  void receiveLoopStarting() {
    logDebug(
      'Receive loop starting.',
      eventId: EventId(47, 'ReceiveLoopStarting'),
    );
  }

  void startingServerTimeoutTimer(Duration serverTimeout) {
    if (isEnabled(LogLevel.debug)) {
      logDebug(
        'Starting server timeout timer. Duration: ${serverTimeout.inMilliseconds.toStringAsFixed(2)}ms',
        eventId: EventId(48, 'StartingServerTimeoutTimer'),
      );
    }
  }

  void notUsingServerTimeout() {
    logDebug(
      'Not using server timeout because the transport inherently tracks server availability.',
      eventId: EventId(49, 'NotUsingServerTimeout'),
    );
  }

  void serverDisconnectedWithError(Exception exception) {
    logError(
      'The server connection was terminated with an error.',
      eventId: EventId(50, 'ServerDisconnectedWithError'),
      exception: exception,
    );
  }

  void invokingClosedEventHandler() {
    logDebug(
      'Invoking the Closed event handler.',
      eventId: EventId(51, 'InvokingClosedEventHandler'),
    );
  }

  void stopping() {
    logDebug(
      'Stopping HubConnection.',
      eventId: EventId(52, 'Stopping'),
    );
  }

  void terminatingReceiveLoop() {
    logDebug(
      'Terminating receive loop.',
      eventId: EventId(53, 'TerminatingReceiveLoop'),
    );
  }

  void waitingForReceiveLoopToTerminate() {
    logDebug(
      'Waiting for the receive loop to terminate.',
      eventId: EventId(54, 'WaitingForReceiveLoopToTerminate'),
    );
  }

  void processingMessage(int messageLength) {
    logDebug(
      'Processing $messageLength byte message from server.',
      eventId: EventId(56, 'ProcessingMessage'),
    );
  }

  void unableToSendCancellation(String invocationId) {
    logTrace(
      'Unable to send cancellation for invocation \'$invocationId\'. The connection is inactive.',
      eventId: EventId(55, 'UnableToSendCancellation'),
    );
  }

  void startingStream(String streamId) {
    logTrace(
      'Initiating stream \'$streamId\'.',
      eventId: EventId(63, 'StartingStream'),
    );
  }

  void sendingStreamItem(String streamId) {
    logTrace(
      'Sending item for stream \'$streamId\'.',
      eventId: EventId(64, 'SendingStreamItem'),
    );
  }

  void cancelingStream(String streamId) {
    logTrace(
      'Stream \'$streamId\' has been canceled by client.',
      eventId: EventId(65, 'CancelingStream'),
    );
  }

  void completingStream(String streamId) {
    logTrace(
      'Sending completion message for stream \'$streamId\'.',
      eventId: EventId(66, 'CompletingStream'),
    );
  }

  void stateTransitionFailed(
    HubConnectionState expectedState,
    HubConnectionState newState,
    HubConnectionState actualState,
  ) {
    logError(
      'The HubConnection failed to transition from the $expectedState state to the $newState state because it was actually in the $actualState state.',
      eventId: EventId(67, 'StateTransitionFailed'),
      exception: Exception(),
    );
  }

  void reconnecting(String streamId) {
    logInformation(
      'HubConnection reconnecting.',
      eventId: EventId(68, 'Reconnecting'),
    );
  }

  void reconnectingWithError(Exception exception) {
    logError(
      'HubConnection reconnecting due to an error.',
      eventId: EventId(69, 'ReconnectingWithError'),
    );
  }

  void reconnected(int reconnectAttempts, Duration elapsedTime) {
    logInformation(
      'HubConnection reconnected successfully after $reconnectAttempts attempts and $elapsedTime elapsed.',
      eventId: EventId(70, 'Reconnected'),
    );
  }

  void reconnectAttemptsExhausted(int reconnectAttempts, Duration elapsedTime) {
    logInformation(
      'Reconnect retries have been exhausted after $reconnectAttempts failed attempts and $elapsedTime elapsed. Disconnecting.',
      eventId: EventId(71, 'ReconnectAttemptsExhausted'),
    );
  }

  void awaitingReconnectRetryDelay(int reconnectAttempts, Duration retryDelay) {
    logTrace(
      'Reconnect attempt number $reconnectAttempts will start in $retryDelay.',
      eventId: EventId(72, 'AwaitingReconnectRetryDelay'),
    );
  }

  void reconnectAttemptFailed(Exception exception) {
    logTrace(
      'Reconnect attempt failed.',
      eventId: EventId(73, 'ReconnectAttemptFailed'),
      exception: exception,
    );
  }

  void errorDuringReconnectingEvent(Exception exception) {
    logError(
      'An exception was thrown in the handler for the Reconnecting event.',
      eventId: EventId(74, 'ErrorDuringReconnectingEvent'),
      exception: exception,
    );
  }

  void errorDuringReconnectedEvent(Exception exception) {
    logError(
      'An exception was thrown in the handler for the Reconnected event.',
      eventId: EventId(75, 'ErrorDuringReconnectedEvent'),
      exception: exception,
    );
  }

  void errorDuringNextRetryDelay(Exception exception) {
    logError(
      'An exception was thrown from RetryPolicy.nextRetryDelay().',
      eventId: EventId(76, 'ErrorDuringNextRetryDelay'),
      exception: exception,
    );
  }

  void firstReconnectRetryDelayNull() {
    logWarning(
      'Connection not reconnecting because the RetryPolicy returned null on the first reconnect attempt.',
      eventId: EventId(77, 'FirstReconnectRetryDelayNull'),
    );
  }

  void reconnectingStoppedDuringRetryDelay() {
    logTrace(
      'Connection stopped during reconnect delay. Done reconnecting.',
      eventId: EventId(78, 'ReconnectingStoppedDuringRetryDelay'),
    );
  }

  void reconnectingStoppedDuringReconnectAttempt() {
    logTrace(
      'Connection stopped during reconnect attempt. Done reconnecting.',
      eventId: EventId(79, 'ReconnectingStoppedDuringReconnectAttempt'),
    );
  }

  void attemptingStateTransition(
    HubConnectionState expectedState,
    HubConnectionState newState,
  ) {
    logTrace(
      'The HubConnection is attempting to transition from the $expectedState state to the $newState state.',
      eventId: EventId(80, 'AttemptingStateTransition'),
    );
  }

  void errorInvalidHandshakeResponse(Exception exception) {
    logError(
      'Received an invalid handshake response."',
      eventId: EventId(81, 'ErrorInvalidHandshakeResponse'),
      exception: exception,
    );
  }

  void errorHandshakeTimedOut(
    Duration handshakeTimeout,
    Exception exception,
  ) {
    logError(
      'The handshake timed out after ${handshakeTimeout.inSeconds} seconds.',
      eventId: EventId(82, 'ErrorHandshakeTimedOut'),
      exception: exception,
    );
  }

  void errorHandshakeCanceled(Exception exception) {
    logError(
      'The handshake was canceled by the client.',
      eventId: EventId(83, 'ErrorHandshakeCanceled'),
      exception: exception,
    );
  }

  void erroredStream(String streamId, Exception exception) {
    logTrace(
      'Client threw an error for stream \'$streamId\'.',
      eventId: EventId(84, 'ErroredStream'),
      exception: exception,
    );
  }

  void missingResultHandler(String target) {
    logWarning(
      'Failed to find a value returning handler for \'$target}\' method. Sending error to server.',
      eventId: EventId(85, 'MissingResultHandler'),
    );
  }

  void resultNotExpected(String target) {
    logWarning(
      'Result given for \'$target\' method but server is not expecting a result.',
      eventId: EventId(86, 'ResultNotExpected'),
    );
  }

  void completingStreamNotSent(String streamId) {
    logTrace(
      'Completion message for stream \'$streamId\' was not sent because the connection is closed.',
      eventId: EventId(87, 'CompletingStreamNotSent'),
    );
  }

  void errorSendingInvocationResult(
    String invocationId,
    String target,
  ) {
    logWarning(
      'Error returning result for invocation \'$invocationId\' for method \'$target\' because the underlying connection is closed.',
      eventId: EventId(88, 'ErrorSendingInvocationResult'),
    );
  }
}
