/// Options used to change behavior of how connections are handled.
class ConnectionOptions {
  ConnectionOptions({this.disconnectTimeout});

  /// Gets or sets the interval used by the server to timeout idle connections.
  Duration? disconnectTimeout;
}
