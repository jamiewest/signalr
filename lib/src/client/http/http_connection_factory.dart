import 'package:extensions/src/primitives/cancellation_token.dart';
import '../../common/http/connections/connection_factory.dart';

/// A factory for creating [HttpConnection] instances.
class HttpConnectionFactory implements ConnectionFactory {
  @override
  Future<void> connect(Uri url, [CancellationToken? cancellationToken]) {
    throw UnimplementedError();
  }
}
