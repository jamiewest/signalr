import 'hub_invocation_message.dart';
import 'message_type.dart';

/// The [CancelInvocationMessage] represents a cancellation of a
/// streaming method.
class CancelInvocationMessage extends HubInvocationMessage {
  /// Initializes a new instance of the [CancelInvocationMessage] class.
  CancelInvocationMessage({
    required super.invocationId,
  }) : super(type: MessageType.cancelInvocation);
}
