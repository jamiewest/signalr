import 'package:extensions/hosting.dart';
import 'package:http/http.dart' as http;

class LoggingHttpMessageHandler extends http.BaseClient {
  final http.Client _inner;
  final Logger _logger;

  LoggingHttpMessageHandler(this._inner, LoggerFactory loggerFactory)
      : _logger = loggerFactory.createLogger('LoggingHttpClient');

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    _logger.sendingHttpRequest(request.method, request.url);
    final response = await _inner.send(request);

    if (response.statusCode != 200 && response.statusCode != 101) {
      _logger.unsuccessfulHttpResponse(
        response.statusCode.toString(),
        request.method,
        request.url,
      );
    }

    return response;
  }
}

extension LoggingExtensions on Logger {
  void sendingHttpRequest(
    String requestMethod,
    Uri requestUrl,
  ) {
    logTrace(
      'Sending HTTP request $requestMethod \'$requestUrl\'.',
      eventId: const EventId(1, 'SendingHttpRequest'),
    );
  }

  void unsuccessfulHttpResponse(
    String statusCode,
    String requestMethod,
    Uri requestUrl,
  ) {
    logWarning(
      'Unsuccessful HTTP response $statusCode return from $requestMethod \'$requestUrl\'.',
      eventId: const EventId(2, 'UnsuccessfulHttpResponse'),
    );
  }
}
