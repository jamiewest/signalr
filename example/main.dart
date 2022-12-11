import 'dart:convert';

import 'package:extensions/logging.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:signalr/signalr.dart';
import 'package:signalr/src/client/http/http_connection.dart';
import 'package:signalr/src/client/http/http_connection_options.dart';
import 'package:signalr/src/common/http/http_transports.dart';
import 'package:sse/server/sse_handler.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

Future<void> main() async {
  final connection = HttpConnection(
    loggerFactory: LoggerFactory.create(
      (logging) => logging
        ..addDebug()
        ..setMinimumLevel(LogLevel.trace),
    ),
    httpConnectionOptions: HttpConnectionOptions(
      url: Uri.parse('ws://localhost:5115/chatHub'),
      skipNegotiation: true,
      transports: HttpTransportType.webSockets.value,
    ),
  );

  await connection.start();

  connection.transport.sink.add('hahahahha');
}

/*
Future<void> main() async {
  var wsHandler = webSocketHandler((webSocket) {
    webSocket.stream.listen((message) {
      print(message);
      webSocket.sink.add('echo $message');
    });
  });

  var sseHandler = SseHandler(Uri.parse('/sseHandler'));

  final handler = Cascade().add(wsHandler).add(sseHandler.handler).handler;

  await shelf_io.serve(handler, '127.0.0.1', 8080).then((server) {
    print('Serving at ws://${server.address.host}:${server.port}');
  });

  var connections = sseHandler.connections;
  while (await connections.hasNext) {
    var connection = await connections.next;
    connection.stream.listen((message) {
      print(message);
      connection.sink.add('echo $message');
    });
  }
}
*/