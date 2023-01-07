/// A handshake request message.
class HandshakeRequestMessage {
  /// Initializes a new instance of the [HandshakeRequestMessage] class.
  const HandshakeRequestMessage({
    required this.protocol,
    required this.version,
  });

  /// Gets the requested protocol name.
  final String protocol;

  /// Gets the requested protocol version.
  final int version;
}

extension HandshakeRequestMessageExtensions on HandshakeRequestMessage {
  Map<String, dynamic> toJson() => {
        'protocol': protocol,
        'version': version,
      };

  static HandshakeRequestMessage fromJson(Map<String, dynamic> json) {
    return HandshakeRequestMessage(
      protocol: json['protocol'] as String,
      version: json['version'] as int,
    );
  }
}
