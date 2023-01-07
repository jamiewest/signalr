/// Exception thrown during negotiate when a transport fails to connect.
class TransportFailedException implements Exception {
  final String _message;

  /// Constructs a [TransportFailedException].
  TransportFailedException({
    required this.transportType,
    required String message,
    Exception? innerException,
  }) : _message = message;

  /// The name of the transport that failed to connect.
  final String transportType;

  @override
  String toString() => '$transportType failed: $_message';
}
