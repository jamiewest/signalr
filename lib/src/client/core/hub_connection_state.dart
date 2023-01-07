/// Describes the current state of the [HubConnection] to the server.
enum HubConnectionState {
  /// The hub connection is disconnected.
  disconnected('Disconnected'),

  /// The hub connection is connected.
  connected('Connected'),

  /// The hub connection is connecting.
  connecting('Connecting'),

  /// The hub connection is reconnecting.
  reconnecting('Reconnecting');

  final String name;
  const HubConnectionState(
    this.name,
  );

  @override
  String toString() => this.name;
}
