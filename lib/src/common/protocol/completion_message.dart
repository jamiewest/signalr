import 'package:signalr/src/common/protocol/message_type.dart';

import 'hub_invocation_message.dart';

/// Represents an invocation that has completed. If there is an error
/// then the invocation didn't complete successfully.
class CompletionMessage extends HubInvocationMessage {
  /// Constructs a [CompletionMessage].
  CompletionMessage({
    required super.invocationId,
    this.error,
    this.result,
    this.hasResult = false,
  }) : super(type: MessageType.completion) {
    if (error != null && hasResult) {
      throw Exception(
        'Expected either \'error\' or \'result\' to be provided, but not both',
      );
    }
  }

  /// Constructs a [CompletionMessage] with an error.
  factory CompletionMessage.withError({
    required String invocationId,
    String? error,
  }) =>
      CompletionMessage(
        invocationId: invocationId,
        error: error,
        result: null,
        hasResult: false,
      );

  /// Constructs a [CompletionMessage] with a result.
  factory CompletionMessage.withResult({
    required String invocationId,
    Object? payload,
  }) =>
      CompletionMessage(
        invocationId: invocationId,
        error: null,
        result: payload,
        hasResult: true,
      );

  /// Constructs a [CompletionMessage] without an error or result.
  /// This means the invocation was successful but there is no return value.
  factory CompletionMessage.empty({
    required String invocationId,
  }) =>
      CompletionMessage(
        invocationId: invocationId,
        error: null,
        result: null,
        hasResult: false,
      );

  /// Optional error message if the invocation wasn't completed
  /// successfully. This must be null if there is a result.
  final String? error;

  /// Optional result from the invocation. This must be null if there
  /// is an error. This can also be null if there wasn't a result from
  /// the method invocation.
  final Object? result;

  /// Specifies whether the completion contains a result.
  final bool hasResult;

  @override
  String toString() {
    final errorStr = error == null ? '<<null>>' : '\'$error\'';
    final resultField = hasResult ? ', Result: ${result ?? '<<null>>'}' : '';
    return 'Completion {{ InvocationId: \'$invocationId\', Error: $errorStr$resultField }}';
  }
}
