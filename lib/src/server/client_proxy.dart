import 'package:extensions/dependency_injection.dart';

/// A proxy abstraction for invoking hub methods.
abstract class ClientProxy {
  /// Invokes a method on the connection(s) represented by the [ClientProxy]
  /// instance. Does not wait for a response from the receiver.
  Future<void> send(
    String method,
    List<Object>? args,
    CancellationToken cancellationToken,
  );
}
