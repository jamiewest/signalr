import 'dart:collection';

import 'hub_connection_context.dart';

class HubConnectionStore with MapMixin<String, HubConnectionContext> {
  final Map<String, HubConnectionContext> _connections =
      <String, HubConnectionContext>{};

  @override
  HubConnectionContext? operator [](Object? key) => _connections[key];

  @override
  void operator []=(String key, HubConnectionContext value) =>
      _connections[key] = HubConnectionContext();

  @override
  void clear() => _connections.clear();

  @override
  Iterable<String> get keys => _connections.keys;

  @override
  HubConnectionContext? remove(Object? key) => _connections.remove(key);
}
