import 'package:signalr/src/common/protocol/message_type.dart';

import 'hub_message.dart';

/// A handshake request message.
class HandshakeRequestMessage extends HubMessage {
  /// Initializes a new instance of the [HandshakeRequestMessage] class.
  const HandshakeRequestMessage({
    required this.protocol,
    required this.version,
  }) : super(type: MessageType.handshakeRequest);

  /// Gets the requested protocol name.
  final String protocol;

  /// Gets the requested protocol version.
  final int version;
}
