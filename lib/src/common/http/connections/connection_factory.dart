import 'package:extensions/primitives.dart';

/// A factory abstraction for creating connections to a url.
abstract class ConnectionFactory {
  /// Creates a new connection to a url.
  Future<void> connect(Uri url, [CancellationToken? cancellationToken]);
}
