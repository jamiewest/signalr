import 'dart:collection';

import '../hub_connection_context.dart';

class HubGroupList with IterableMixin<Map<String, HubConnectionContext>> {
  final Map<String, GroupConnectionList> _groups =
      <String, GroupConnectionList>{};

  operator [](Object? key) => _groups[key];

  void add(HubConnectionContext connection, String groupName) {}

  void _createOrUpdateGroupWithConnection(
    String groupName,
    HubConnectionContext connection,
  ) {
    //_groups[groupName] =
  }

  static GroupConnectionList addConnectionToGroup(
    HubConnectionContext connection,
    GroupConnectionList group,
  ) {
    group[connection.connectionId] = connection;
  }

  @override
  Iterator<Map<String, HubConnectionContext>> get iterator =>
      _groups.values.iterator;
}

class GroupConnectionList with MapMixin<String, HubConnectionContext> {
  final Map<String, HubConnectionContext> _items =
      <String, HubConnectionContext>{};

  @override
  HubConnectionContext? operator [](Object? key) => _items[key];

  @override
  void operator []=(String key, HubConnectionContext value) =>
      _items[key] = value;

  @override
  void clear() => _items.clear();

  @override
  Iterable<String> get keys => _items.keys;

  @override
  HubConnectionContext? remove(Object? key) => _items[key];

  @override
  bool operator ==(Object obj) {
    if (obj is Map<String, HubConnectionContext>) {
      return obj.length == length;
    }

    return false;
  }
}
