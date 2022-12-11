enum MessageType {
  /// MessageType is not defined.
  undefined(0, '0'),

  /// Indicates the message is an Invocation message and
  /// implements the [InvocationMessage] interface.
  invocation(1, 'invocation'),

  /// Indicates the message is a StreamItem message and
  /// implements the [StreamItemMessage] interface.
  streamItem(2, 'streamItem'),

  /// Indicates the message is a Completion message and
  /// implements the [CompletionMessage] interface.
  completion(3, 'completion'),

  /// Indicates the message is a Stream Invocation message
  /// and implements the [StreamInvocationMessage] interface.
  streamInvocation(4, 'streamInvocation'),

  /// Indicates the message is a Cancel Invocation message
  /// and implements the [CancelInvocationMessage] interface.
  cancelInvocation(5, 'cancelInvocation'),

  /// Indicates the message is a Ping message and implements
  /// the [PingMessage] interface.
  ping(6, 'ping'),

  /// Indicates the message is a Close message and implements
  /// the [CloseMessage] interface.
  close(7, 'close'),

  /// Indicates the message is a Handshake Request message and
  /// implements the [HandshakeRequest] interface.
  handshakeRequest(8, 'handshakeRequest'),

  /// Indicates the message is a Handshake Response message and
  /// implements the [HandshakeResponse] interface.
  handshakeResponse(9, 'handshakeResponse');

  final int code;
  final String name;
  const MessageType(
    this.code,
    this.name,
  );
}
