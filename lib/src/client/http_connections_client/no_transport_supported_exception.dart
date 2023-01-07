/// Exception thrown during negotiate when there are no supported
/// transports between the client and server.
class NoTransportSupportedException implements Exception {
  final String _message;

  /// Constructs a [NoTransportSupportedException].
  NoTransportSupportedException({
    required String message,
  }) : _message = message;

  @override
  String toString() => '$Exception: $_message';
}
