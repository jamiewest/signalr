/// A handshake response message.
class HandshakeResponseMessage {
  /// Initializes a new instance of the [HandshakeResponseMessage] class.
  /// An error response does need a minor version. Since the handshake has
  /// failed, any extra data will be ignored.
  const HandshakeResponseMessage({
    this.error,
  });

  /// Gets the optional error message.
  final String? error;

  /// An empty response message with no error.
  static HandshakeResponseMessage get empty =>
      const HandshakeResponseMessage(error: null);
}

extension HandshakeResponseMessageExtensions on HandshakeResponseMessage {
  Map<String, dynamic> toJson() => {
        'error': error ?? '',
      };

  static HandshakeResponseMessage fromJson(Map<String, dynamic> json) =>
      HandshakeResponseMessage(
        error: json['error'] as String?,
      );
}
