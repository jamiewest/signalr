import 'package:extensions/logging.dart';

import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'http_transport.dart';

class WebSocketsServerTransport implements HttpTransport {
  final Logger _logger;
  final StreamChannel _application;

  WebSocketsServerTransport(
    StreamChannel application,
    LoggerFactory loggerFactory,
  )   : _application = application,
        _logger = loggerFactory.createLogger('WebSocketsTransport');

  @override
  Future<void> processRequest() {
    webSocketHandler((WebSocketChannel channel) {
      _startReceiving(channel);
      _startSending(channel);
    });
    return Future.value();
  }

  void _startReceiving(WebSocketChannel channel) {
    channel.stream.listen((message) {
      _application.sink.add(message);
    });
  }

  void _startSending(WebSocketChannel channel) {
    _application.stream.listen((message) {
      channel.sink.add(message);
    });
  }
}
