import 'message_type.dart';

/// A base class for hub messages.
abstract class HubMessage {
  const HubMessage({this.type});

  /// A [MessageType] value indicating the type of this message.
  final MessageType? type;
}
