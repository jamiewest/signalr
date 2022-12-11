import 'hub.dart';

/// A [Hub] activator abstraction.
abstract class HubActivator<THub extends Hub> {
  /// Creates a hub.
  THub create();

  /// Releases the specified hub.
  void release(THub hub);
}
