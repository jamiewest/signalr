/// Specifies transports that the client can use to send HTTP requests.
enum HttpTransportType {
  /// Specifies that no transport is used.
  none(0, 'None'),

  /// Specifies that the web sockets transport is used.
  webSockets(1, 'WebSockets'),

  /// Specifies that the server sent events transport is used.
  serverSentEvents(2, 'ServerSentEvents'),

  /// Specifies that the long polling transport is used.
  longPolling(4, 'LongPolling');

  const HttpTransportType(
    this.value,
    this.name,
  );

  final int value;

  final String name;
}
