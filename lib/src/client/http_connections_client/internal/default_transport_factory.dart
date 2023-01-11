import 'package:extensions/hosting.dart';
import 'package:http/http.dart';

import '../../../common/http_connections_common/http_transport_type.dart';
import '../../../common/http_connections_common/http_transports.dart';
import '../http_connection_options.dart';

import 'transport.dart';
import 'transport_factory.dart';
import 'web_socket_transport.dart';

class DefaultTransportFactory implements TransportFactory {
  final BaseClient? _httpClient;
  final HttpConnectionOptions _httpConnectionOptions;
  final AccessTokenProvider _accessTokenProvider;
  final Iterable<HttpTransportType> _requestedTransportType;
  final LoggerFactory _loggerFactory;
  static bool _webSocketsSupported = true;

  DefaultTransportFactory({
    required Iterable<HttpTransportType> requestedTransportType,
    required LoggerFactory loggerFactory,
    required BaseClient? httpClient,
    required HttpConnectionOptions httpConnectionOptions,
    required AccessTokenProvider accessTokenProvider,
  })  : _requestedTransportType = requestedTransportType,
        _loggerFactory = loggerFactory,
        _httpClient = httpClient,
        _httpConnectionOptions = httpConnectionOptions,
        _accessTokenProvider = accessTokenProvider;

  @override
  Transport createTransport(
      Iterable<HttpTransportType> availableServerTransports) {
    if (_webSocketsSupported &&
        availableServerTransports.hasWebSockets &&
        _requestedTransportType.hasWebSockets) {
      try {
        return WebSocketTransport(
          _httpConnectionOptions,
          _loggerFactory,
          _accessTokenProvider,
          _httpClient,
        );
      } on Exception catch (ex) {
        _loggerFactory.createLogger('DefaultTransportFactory').logDebug(
              'Transport \'${HttpTransportType.webSockets}\' is not supported.',
              eventId: const EventId(1, 'TransportNotSupport'),
              exception: ex,
            );
        _webSocketsSupported = false;
      }
    }

    // if (availableServerTransports
    //         .contains(HttpTransportType.serverSentEvents) &&
    //     _requestedTransportType.contains(HttpTransportType.serverSentEvents)) {
    //   // ServerSentEvents
    // }

    // if (availableServerTransports.contains(HttpTransportType.longPolling) &&
    //     _requestedTransportType.contains(HttpTransportType.longPolling)) {
    //   // LongPolling
    // }

    throw Exception('No requested transports available on the server.');
  }
}
