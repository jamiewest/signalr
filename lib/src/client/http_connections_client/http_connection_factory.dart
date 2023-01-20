import 'package:extensions/logging.dart';
import 'package:extensions/options.dart';

import '../../common/http_connections/connection_context.dart';
import '../../common/http_connections/connection_factory.dart';
import '../../common/http_connections_common/end_point.dart';
import '../../common/http_connections_common/uri_end_point.dart';
import 'http_connection.dart';
import 'http_connection_options.dart';

/// A factory for creating [HttpConnection] instances.
class HttpConnectionFactory implements ConnectionFactory {
  final HttpConnectionOptions _httpConnectionOptions;
  final LoggerFactory _loggerFactory;

  /// Initializes a new instance of the [HttpConnectionFactory] class.
  HttpConnectionFactory(
    Options<HttpConnectionOptions> options,
    LoggerFactory loggerFactory,
  )   : _httpConnectionOptions = options.value!,
        _loggerFactory = loggerFactory;

  @override
  Future<ConnectionContext> connect(EndPoint endPoint,
      [CancellationToken? cancellationToken]) async {
    if (!(endPoint is UriEndPoint)) {
      throw Exception('The provided EndPoint must be of type UriEndPoint.');
    }

    if (_httpConnectionOptions.url != null &&
        _httpConnectionOptions.url != endPoint.uri) {
      throw Exception(
        'If HttpConnectionOptions.Url was set, it must match the'
        ' UriEndPoint.Uri passed to Connect.',
      );
    }

    final connection = HttpConnection(
      httpConnectionOptions: _httpConnectionOptions,
      loggerFactory: _loggerFactory,
    );

    try {
      await connection.start(cancellationToken: cancellationToken);
      return connection;
    } on Exception {
      await connection.disposeAsync();
      rethrow;
    }
  }
}
