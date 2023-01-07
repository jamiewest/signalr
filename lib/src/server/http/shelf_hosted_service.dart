import 'dart:async';
import 'dart:io';

import 'package:extensions/hosting.dart';
import 'package:shelf/shelf.dart';

import 'package:shelf/shelf_io.dart' as shelf_io;

class ShelfHostedService extends HostedService {
  HttpServer? _httpServer;

  final List<FutureOr<Response> Function(Request)> _handlers;
  ShelfHostedService(List<FutureOr<Response> Function(Request)> handlers)
      : _handlers = handlers;

  @override
  Future<void> start(CancellationToken cancellationToken) async {
    final cascade = Cascade();
    _handlers.forEach((handler) => cascade.add(handler));

    final handler = cascade.handler;

    _httpServer = await shelf_io.serve(handler, '127.0.0.1', 8080);
    print('Serving at ws://${_httpServer!.address.host}:${_httpServer!.port}');
  }

  @override
  Future<void> stop(CancellationToken cancellationToken) async {
    await _httpServer?.close();
  }
}
