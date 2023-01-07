import 'dart:convert';

import "package:os_detect/os_detect.dart" as platform;
import 'package:extensions/logging.dart';
import 'package:extensions/options.dart';
import 'package:http/http.dart';
import 'package:quiver/strings.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:uri/uri.dart';

import 'package:signalr/src/client/http_connections_client/internal/access_token_http_message_handler.dart';
import 'package:signalr/src/common/http_connections/connection_factory.dart';
import 'package:signalr/src/common/http_connections_common/end_point.dart';

import '../../common/http_connections/connection_context.dart';
import '../../common/http_connections_common/http_transport_type.dart';
import '../../common/http_connections_common/uri_end_point.dart';
import '../../common/signalr_common/protocol/transfer_format.dart';

import 'http_connection.dart';
import 'http_connection_logger_extensions.dart';
import 'http_connection_options.dart';
import 'internal/default_transport_factory.dart';
import 'internal/http_client_handler.dart';
import 'internal/logging_http_message_handler.dart';
import 'internal/transport.dart';
import 'internal/transport_factory.dart';
import 'streamed_response_extensions.dart';
import 'transport_failed_exception.dart';

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
        'If HttpConnectionOptions.Url was set, it must match the UriEndPoint.Uri passed to Connect.',
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
