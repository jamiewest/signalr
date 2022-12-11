import 'dart:async';

import 'package:extensions/logging.dart';
import 'package:http/http.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../common/protocol/transfer_format.dart';
import '../http_connection_options.dart';
import 'transport.dart';

class WebSocketTransport extends Transport {
  final Logger _logger;
  final HttpConnectionOptions _httpConnectionOptions;
  final BaseClient? _httpClient;
  final Duration _closeTimeout;
  WebSocketChannel? _channel;
  StreamController _controller = StreamController();

  WebSocketTransport(
    HttpConnectionOptions httpConnectionOptions,
    LoggerFactory loggerFactory,
    AccessTokenProvider accessTokenProvider,
    BaseClient? httpClient,
  )   : _httpConnectionOptions = httpConnectionOptions,
        _logger = loggerFactory.createLogger('WebSocketsTransport'),
        _closeTimeout = httpConnectionOptions.closeTimeout,
        _httpClient = httpClient {
    _httpConnectionOptions.accessTokenProvider = accessTokenProvider;
  }

  @override
  StreamSink get sink => _channel!.sink;

  @override
  Stream get stream => _controller.stream;

  @override
  Future<void> start({
    required Uri uri,
    required TransferFormat transferFormat,
    required CancellationToken? cancellationToken,
  }) {
    _channel = WebSocketChannel.connect(uri);
    if (_channel == null) {
      throw Exception('Unable to get channel');
    }

    _channel!.stream.listen((e) => _controller.add(e));
    //await _channel!.stream.listen((e) => _controller.add(e)).asFuture();
    return Future.value();
  }

  @override
  Future<void> stop() async {
    await _channel!.sink.close();
  }
}
