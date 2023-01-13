import 'hub_message.dart';
import 'message_type.dart';

/// A keep-alive message to let the other side of the connection know
/// that the connection is still alive.
class PingMessage extends HubMessage {
  /// Creates a new [PingMessage].
  const PingMessage() : super(type: MessageType.ping);

  /// A static instance of the [PingMessage] to remove unneeded allocations.
  static PingMessage get instance => const PingMessage();
}
