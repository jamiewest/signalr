/// Specifies transports that the client can use to send HTTP requests.
enum HttpTransportType {
  /// Specifies that no transport is used.
  none(0),

  /// Specifies that the web sockets transport is used.
  webSockets(1),

  /// Specifies that the server sent events transport is used.
  serverSentEvents(2),

  /// Specifies that the long polling transport is used.
  longPolling(4);

  const HttpTransportType(this.value);

  final int value;
}
