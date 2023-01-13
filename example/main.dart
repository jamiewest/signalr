import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:extensions/logging.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:signalr/src/client/core/hub_connection_builder.dart';
import 'package:signalr/src/client/hub_connection_builder_http_extensions.dart';
import 'package:signalr/src/common/protocols_json/json_protocol_dependency_injection_extensions.dart';
import 'package:sse/server/sse_handler.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:signalr/signalr.dart';
import 'package:signalr/src/client/http_connections_client/http_connection.dart';
import 'package:signalr/src/client/http_connections_client/http_connection_options.dart';
import 'package:signalr/src/common/http_connections_common/http_transport_type.dart';

Future<void> main() async {
  final hubConnection = HubConnectionBuilder()
      .addJsonProtocol()
      .configureLogging((logging) => logging
        ..addDebug()
        ..setMinimumLevel(LogLevel.trace))
      .withUrl(
        Uri.parse('http://localhost:5115/chatHub'),
      )
      .build();

  await hubConnection.start();

  // final connection = HttpConnection(
  //   loggerFactory: LoggerFactory.create(
  //     (logging) => logging
  //       ..addDebug()
  //       ..setMinimumLevel(LogLevel.trace),
  //   ),
  //   httpConnectionOptions: HttpConnectionOptions(
  //     url: Uri.parse('http://localhost:5115/chatHub'),
  //     //skipNegotiation: true,
  //     transports: [HttpTransportType.webSockets],
  //   ),
  // );

  // await connection.start();

  // connection.transport.sink.add(utf8.encode('hahahahha'));
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