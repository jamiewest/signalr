import 'package:signalr/src/common/protocol/message_type.dart';

import 'hub_message.dart';

/// A handshake response message.
class HandshakeResponseMessage extends HubMessage {
  /// Initializes a new instance of the [HandshakeResponseMessage] class.
  /// An error response does need a minor version. Since the handshake has
  /// failed, any extra data will be ignored.
  const HandshakeResponseMessage({
    this.error,
  }) : super(type: MessageType.handshakeResponse);

  /// Gets the optional error message.
  final String? error;

  /// An empty response message with no error.
  static HandshakeResponseMessage get empty =>
      HandshakeResponseMessage(error: null);
}
