typedef ProtocolSelectorDefinition = List<String> Function(String value);

/// Options used by the WebSockets transport to modify the transports behavior.
class WebSocketOptions {
  WebSocketOptions({
    this.closeTimeout = const Duration(seconds: 5),
  });

  /// Gets or sets the amount of time the WebSocket transport will wait
  /// for a graceful close before starting an ungraceful close.
  Duration closeTimeout;

  /// Gets or sets a delegate that will be called when a new WebSocket is
  /// established to select the value for the `Sec-WebSocket-Protocol`
  /// response header. The delegate will be called with a list of the
  /// protocols provided by the client in the `Sec-WebSocket-Protocol`
  /// request header.
  ProtocolSelectorDefinition? subProtocolSelector;
}
