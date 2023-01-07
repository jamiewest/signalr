import 'package:http/http.dart' as http;

class HttpClientHandler extends http.BaseClient {
  final http.Client _inner;
  final Map<String, Object> _properties = <String, Object>{};

  HttpClientHandler(
    this._inner,
  );

  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    _properties.clear();

    if (request is HttpRequestMessage) {
      _properties.addAll(request.properties);
    }

    final response = await _inner.send(request);

    return HttpResponseMessage(response, _properties);
  }
}

class HttpRequestMessage extends http.Request {
  final Map<String, Object> _properties;

  HttpRequestMessage(
    super.method,
    super.url,
    Map<String, Object>? properties,
  ) : _properties = properties ?? <String, Object>{};

  Map<String, Object> get properties => _properties;
}

class HttpResponseMessage implements http.StreamedResponse {
  final http.StreamedResponse _inner;
  final Map<String, Object> _properties;

  HttpResponseMessage(
    http.StreamedResponse inner,
    Map<String, Object>? properties,
  )   : _inner = inner,
        _properties = properties ?? <String, Object>{};

  HttpResponseMessage.bytes(
    http.StreamedResponse inner,
    Map<String, Object>? properties,
  )   : _inner = inner,
        _properties = properties ?? <String, Object>{};

  Map<String, Object> get properties => _properties;

  @override
  int? get contentLength => _inner.contentLength;

  @override
  Map<String, String> get headers => _inner.headers;

  @override
  bool get isRedirect => _inner.isRedirect;

  @override
  bool get persistentConnection => _inner.persistentConnection;

  @override
  String? get reasonPhrase => _inner.reasonPhrase;

  @override
  http.BaseRequest? get request => _inner.request;

  @override
  int get statusCode => _inner.statusCode;

  @override
  http.ByteStream get stream => _inner.stream;
}
