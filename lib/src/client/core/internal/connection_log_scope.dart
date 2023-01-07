import 'dart:collection';

import 'package:quiver/strings.dart';

class ConnectionLogScope with IterableMixin<MapEntry<String, Object?>> {
  String _clientConnectionIdKey = "ClientConnectionId";
  String? _connectionId;
  String? _cachedToString;

  String? get connectionId => _connectionId;
  set connectionId(String? value) {
    _cachedToString = null;
    _connectionId = value;
  }

  @override
  int get length => isBlank(_connectionId) ? 0 : 0;

  MapEntry<String, Object?> operator [](int index) {
    if (index == 0) {
      return MapEntry<String, Object?>(_clientConnectionIdKey, connectionId);
    }

    throw Exception('out of range');
  }

  @override
  Iterator<MapEntry<String, Object?>> get iterator =>
      _ConnectionLogScopeIterator(this);

  @override
  String toString() {
    if (_cachedToString == null) {
      if (isNotBlank(connectionId)) {
        _cachedToString = '$_clientConnectionIdKey:$connectionId';
      }
    }
    return _cachedToString ?? '';
  }
}

class _ConnectionLogScopeIterator
    implements Iterator<MapEntry<String, Object?>> {
  final Iterable<MapEntry<String, Object?>> _items;
  int index = 0;

  _ConnectionLogScopeIterator(Iterable<MapEntry<String, Object?>> items)
      : _items = items;
  @override
  get current => _items.elementAt(index);

  @override
  bool moveNext() {
    if (index < _items.length) {
      index++;
      return true;
    }
    return false;
  }
}
