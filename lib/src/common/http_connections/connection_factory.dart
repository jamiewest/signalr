import 'package:extensions/primitives.dart';

import '../http_connections_common/end_point.dart';

import 'connection_context.dart';

/// A factory abstraction for creating connections to a url.
abstract class ConnectionFactory {
  /// Creates a new connection to a url.
  Future<ConnectionContext> connect(EndPoint endPoint,
      [CancellationToken? cancellationToken]);
}
