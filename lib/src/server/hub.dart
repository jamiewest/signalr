import 'package:extensions/primitives.dart';

abstract class Hub implements Disposable {
  Map<String, Function>? _methods;
  bool _disposed = false;

  void on(String method, Function handler) {
    if (method == 'connect') {
      onConnected();
    } else if (method == 'disconnect') {
      //onDisconnected()
    }
  }

  @override
  void dispose() {
    if (_disposed) {
      return;
    }

    _disposed = true;
  }

  /// Called when a new connection is established with the hub.
  Future<void> onConnected();

  /// Called when a connection with the hub is terminated.
  Future<void> onDisconnected(Exception? exception);

  void _checkDisposed() {
    if (_disposed) {
      throw Exception('ObjectDisposedException(GetType().Name)');
    }
  }
}
