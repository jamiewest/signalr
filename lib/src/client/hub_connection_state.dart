/// Describes the current state of the [HubConnection] to the server.
enum HubConnectionState {
  /// The hub connection is disconnected.
  disconnected,

  /// The hub connection is connected.
  connected,

  /// The hub connection is connecting.
  connecting,

  /// The hub connection is reconnecting.
  reconnecting,
  ;

  @override
  String toString() => this.name;
}
