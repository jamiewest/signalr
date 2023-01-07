import 'package:extensions/hosting.dart';
import 'package:http/http.dart' as http;
import 'package:quiver/strings.dart';
import '../http_connection_logger_extensions.dart';
import 'http_client_handler.dart';

import '../http_connection.dart';

class AccessTokenHttpMessageHandler extends http.BaseClient {
  final http.Client _inner;
  final HttpConnection _httpConnection;
  final Logger _logger;
  String? _accessToken;

  AccessTokenHttpMessageHandler(
    this._inner,
    HttpConnection httpConnection,
    LoggerFactory loggerFactory,
  )   : _httpConnection = httpConnection,
        _logger = loggerFactory.createLogger('HttpConnection');

  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    var shouldRetry = true;

    if (isBlank(_accessToken)) {
      shouldRetry = false;
      _accessToken = await _httpConnection.getAccessToken();
    }

    if (request is HttpRequestMessage) {
      if (request.properties.containsKey('IsNegotiate')) {
        if (request.properties['IsNegotiate'] == true) {
          shouldRetry = false;
          _accessToken = await _httpConnection.getAccessToken();
        }
      }
    }

    _setAccessToken(_accessToken, request);

    var result = await _inner.send(request);
    // retry once with a new token on auth failure
    if (shouldRetry && result.statusCode == 401) {
      _logger.retryAccessToken(result.statusCode);
      _accessToken = await _httpConnection.getAccessToken();

      _setAccessToken(_accessToken, request);

      result = await _inner.send(request);
    }

    return result;
  }

  static void _setAccessToken(
    String? accessToken,
    http.BaseRequest request,
  ) {
    if (isNotBlank(accessToken)) {
      request.headers['Authorization'] = 'Bearer $accessToken';
    }
  }
}
