import 'dart:convert';

import 'package:extensions/logging.dart';
import 'package:http/http.dart';

import "package:os_detect/os_detect.dart" as platform;
import 'package:quiver/strings.dart';
import 'transport_failed_exception.dart';
import 'package:stream_channel/stream_channel.dart';
import 'http_connection_logger_extensions.dart';
import 'internal/logging_http_client.dart';
import 'streamed_response_extensions.dart';
import '../../common/http/http_transports.dart';
import '../../common/http/negotiation_response.dart';
import 'package:uri/uri.dart';

import '../../common/protocol/transfer_format.dart';
import 'http_connection_options.dart';
import '../../common/http/http_transport_type.dart';
import 'internal/default_transport_factory.dart';
import 'internal/transport.dart';
import 'internal/transport_factory.dart';

/// Used to make a connection to an ASP.NET Core ConnectionHandler using
/// an HTTP-based transport.
class HttpConnection implements AsyncDisposable {
  final int _maxRedirects = 100;
  final int _protocolVersionNumber = 1;
  final AccessTokenProvider _noAccessToken = () => Future<String?>.value();
  final Duration _httpClientTimeout = const Duration(seconds: 120);
  final Logger _logger;
  bool _started = false;
  final bool _disposed = false;
  bool _hasInherentKeepAlive = false;
  BaseClient? _httpClient;
  final HttpConnectionOptions _httpConnectionOptions;
  Transport? _transport;
  late final TransportFactory _transportFactory;
  String? _connectionId;
  final LoggerFactory _loggerFactory;
  final Uri _url;
  AccessTokenProvider? _accessTokenProvider;

  /// Initializes a new instance of the [HttpConnection] class.
  HttpConnection({
    required HttpConnectionOptions httpConnectionOptions,
    LoggerFactory? loggerFactory = const NullLoggerFactory(),
  })  : _loggerFactory = loggerFactory!,
        _logger = loggerFactory.createLogger('HttpConnection'),
        _httpConnectionOptions = httpConnectionOptions,
        _url = httpConnectionOptions.url! {
    if (!httpConnectionOptions.skipNegotiation ||
        !hasTransport(
          httpConnectionOptions.transports!,
          HttpTransportType.webSockets,
        )) {
      _httpClient = _createHttpClient();
    }

    if (hasTransport(
          httpConnectionOptions.transports!,
          HttpTransportType.serverSentEvents,
        ) &&
        platform.isBrowser) {
      throw Exception(
        'ServerSentEvents can not be the only transport specified when running in the browser.',
      );
    }

    _transportFactory = DefaultTransportFactory(
      requestedTransportType: httpConnectionOptions.transports!,
      loggerFactory: loggerFactory,
      httpClient: _httpClient,
      httpConnectionOptions: httpConnectionOptions,
      accessTokenProvider: _getAccessToken(),
    );
  }

  StreamChannelMixin get transport {
    _checkDisposed();
    if (_transport == null) {
      throw Exception(
        'Cannot access the ${_transport.toString()} pipe before the connection has started',
      );
    }
    return _transport!;
  }

  Future<void> start({
    TransferFormat? transferFormat,
    CancellationToken? cancellationToken,
  }) async {
    await _startCore(
      transferFormat:
          transferFormat ?? _httpConnectionOptions.defaultTransferFormat,
      cancellationToken: cancellationToken,
    );
  }

  Future<void> _startCore({
    required TransferFormat transferFormat,
    CancellationToken? cancellationToken,
  }) async {
    _checkDisposed();
    if (_started) {
      _logger.skippingStart();
      return;
    }

    _logger.starting();

    await _selectAndStartTransport(
      transferFormat: transferFormat,
      cancellationToken: cancellationToken,
    );

    _started = true;
    _logger.started();
  }

  Future<void> _selectAndStartTransport({
    required TransferFormat transferFormat,
    CancellationToken? cancellationToken,
  }) async {
    var uri = _url;
    // Set the initial access token provider back to the original one
    // from options
    _accessTokenProvider = _httpConnectionOptions.accessTokenProvider;

    final transportExceptions = <Exception>[];

    if (_httpConnectionOptions.skipNegotiation) {
      if (hasTransport(
        _httpConnectionOptions.transports!,
        HttpTransportType.webSockets,
      )) {
        _logger.startingTransport(HttpTransportType.webSockets, uri);
        await _startTransport(
          uri,
          _httpConnectionOptions.transports!,
          transferFormat,
          cancellationToken,
        );
      } else {
        throw Exception(
          'Negotiation can only be skipped when using the WebSocket transport directly.',
        );
      }
    } else {
      NegotiationResponse? negotiationResponse;
      var redirects = 0;

      do {
        negotiationResponse = await _getNegotiationResponse(
          uri,
          cancellationToken,
        );

        if (negotiationResponse.url != null) {
          uri = Uri.parse(negotiationResponse.url!);
        }

        if (negotiationResponse.accessToken != null) {
          String accessToken = negotiationResponse.accessToken!;
          // Set the current access token factory so that future
          // requests use this access token
          _accessTokenProvider = () => Future.value(accessToken);
        }

        redirects++;
      } while (negotiationResponse.url != null && redirects < _maxRedirects);

      if (redirects == _maxRedirects && negotiationResponse.url != null) {
        throw new Exception("Negotiate redirection limit exceeded.");
      }

      // This should only need to happen once
      var connectUrl =
          _createConnectUrl(uri, negotiationResponse.connectionToken);

      // We're going to search for the transfer format as a string because we
      // don't want to parse all the transfer formats in the negotiation
      // response, and we want to allow transfer formats we don't understand
      // in the negotiate response.
      var transferFormatString = transferFormat.toString();

      for (var transport in negotiationResponse.availableTransports!) {
        final transportTypes = Map.fromIterable(
          HttpTransportType.values,
          key: (k) => k.toString(),
          value: (v) => v,
        );

        if (!transportTypes.containsKey(transport.transport)) {
          _logger.transportNotSupported(transport.transport!);
          transportExceptions.add(TransportFailedException(
            transportType: transport.transport!,
            message: 'The transport is not supported by the client.',
          ));
        }

        final transportType = transportTypes[transport.transport!];

        try {
          if ((transportType & _httpConnectionOptions.transports) == 0) {
            _logger.transportDisabledByClient(transportType);
            transportExceptions.add(
              TransportFailedException(
                transportType: transportType.toString(),
                message: 'The transport is disabled by the client.',
              ),
            );
          } else if (!transport.transferFormats!
              .contains(transferFormatString)) {
            _logger.transportDoesNotSupportTransferFormat(
              transportType,
              transferFormat,
            );
            transportExceptions.add(
              TransportFailedException(
                transportType: transportType,
                message:
                    'The transport does not support the \'${transferFormat.toString()}\' transfer format.',
              ),
            );
          } else {
            // The negotiation response gets cleared in the fallback scenario.
            if (negotiationResponse == null) {
              negotiationResponse =
                  await _getNegotiationResponse(uri, cancellationToken);
              connectUrl = _createConnectUrl(
                uri,
                negotiationResponse.connectionToken,
              );
            }

            _logger.startingTransport(transportType, uri);
            await _startTransport(
              connectUrl,
              transportType,
              transferFormat,
              cancellationToken,
            );
            break;
          }
        } on Exception catch (ex) {
          _logger.transportFailed(transportType, ex);

          transportExceptions.add(
            TransportFailedException(
              transportType: transportType.toString(),
              message: '', // TODO: Figure out what this should be.
              innerException: ex,
            ),
          );

          // Try the next transport
          // Clear the negotiation response so we know to re-negotiate.
          negotiationResponse = null;
        }
      }
    }

    if (_transport == null) {
      if (transportExceptions.isNotEmpty) {
        // throw new AggregateException("Unable to connect to the server with any of the available transports.", transportExceptions);
      } else {
        // throw new NoTransportSupportedException("None of the transports supported by the client are supported by the server.");
      }
    }
  }

  Future<NegotiationResponse> _negotiate(
    Uri url,
    BaseClient httpClient,
    Logger logger,
    CancellationToken? cancellationToken,
  ) async {
    try {
      // Get a connection ID from the server
      _logger.establishingConnection(url);

      final urlBuilder = UriBuilder.fromUri(url);
      if (!urlBuilder.path.endsWith('/')) {
        urlBuilder.path += '/';
      }
      urlBuilder.path += 'negotiate';
      Uri uri;
      if (urlBuilder.queryParameters.containsKey('negotiationVersion')) {
        uri = urlBuilder.build();
      } else {
        urlBuilder.queryParameters['negotiateVersion'] =
            _protocolVersionNumber.toString();
        uri = urlBuilder.build();
      }

      final request = Request('POST', uri);

      final streamedResponse = await httpClient.send(request);
      streamedResponse.ensureSuccessStatusCode();

      final response = await Response.fromStream(streamedResponse);

      final result = json.decode(response.body) as Map<String, dynamic>;

      final negotiationResponse = NegotiationResponse.fromJson(result);

      _logger.connectionEstablished(negotiationResponse.connectionId!);
      return negotiationResponse;
    } on Exception catch (ex) {
      _logger.errorWithNegotiation(url, ex);
      rethrow;
    }
  }

  static Uri _createConnectUrl(
    Uri url,
    String? connectionId,
  ) {
    if (isBlank(connectionId)) {
      throw Exception('Invalid connection id.');
    }

    final uriBuilder = UriBuilder.fromUri(url)
      ..queryParameters['id'] = connectionId!;

    return uriBuilder.build();
  }

  Future<void> _startTransport(
    Uri connectUrl,
    int transportType,
    TransferFormat transferFormat,
    CancellationToken? cancellationToken,
  ) async {
    // Construct the transport
    final transport = _transportFactory.createTransport(transportType);

    try {
      await transport.start(
        uri: connectUrl,
        transferFormat: transferFormat,
        cancellationToken: cancellationToken,
      );
    } on Exception catch (ex) {
      _logger.errorStartingTransport(HttpTransportType.webSockets, ex);

      _transport = null;
      rethrow;
    }

    // Disable keep alives for long polling
    _hasInherentKeepAlive = transportType == HttpTransportType.longPolling;

    // We successfully started, set the transport properties
    // (we don't want to set these until the transport is definitely running).
    _transport = transport;

    _logger.transportStarted(HttpTransportType.webSockets);
  }

  BaseClient _createHttpClient() {
    final httpClient = LoggingHttpClient(Client(), _loggerFactory);

    return httpClient;
  }

  AccessTokenProvider _getAccessToken() {
    if (_accessTokenProvider == null) {
      return _noAccessToken;
    }
    return _accessTokenProvider!;
  }

  void _checkDisposed() {
    if (_disposed) {
      throw Exception('Disposed');
    }
  }

  static bool isWebSocketsSupported() {
    return true;
  }

  Future<NegotiationResponse> _getNegotiationResponse(
    Uri url,
    CancellationToken? cancellationToken,
  ) async {
    final negotiationResponse = await _negotiate(
      url,
      _httpClient!,
      _logger,
      cancellationToken,
    );
    // If the negotiationVersion is greater than zero then we know that
    // the negotiation response contains a connectionToken that will
    // be required to connect. Otherwise we just set the connectionId
    // and the connectionToken on the client to the same value.

    _connectionId = negotiationResponse.connectionId!;
    if (negotiationResponse.version == 0) {
      negotiationResponse.connectionToken = _connectionId;
    }

    // _logScope.ConnectionId = _connectionId;
    return negotiationResponse;
  }

  @override
  void abort({Exception? abortReason}) {}

  @override
  Future<void> disposeAsync() {
    throw UnimplementedError();
  }
}

/// Remove this after Extensions update
/// An [LoggerFactory] used to create instance of
///[NullLogger] that logs nothing.
class NullLoggerFactory implements LoggerFactory {
  /// Creates a new [NullLoggerFactory] instance.
  const NullLoggerFactory();

  /// Returns the shared instance of [NullLoggerFactory].
  static NullLoggerFactory get instance => const NullLoggerFactory();

  /// This returns a [NullLogger] instance which logs nothing.
  @override
  Logger createLogger(String categoryName) => NullLogger();

  /// This method ignores the parameter and does nothing.
  @override
  void addProvider(LoggerProvider loggerProvider) {}

  @override
  void dispose() {}
}

class NullLogger extends Logger {
  @override
  Disposable beginScope<TState>(TState state) {
    throw UnimplementedError();
  }

  @override
  bool isEnabled(LogLevel logLevel) {
    return true;
  }

  @override
  void log<TState>(
      {required LogLevel logLevel,
      required EventId eventId,
      required TState state,
      Exception? exception,
      required LogFormatter<TState> formatter}) {
    // TODO: implement log
  }
}
