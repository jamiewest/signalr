import 'package:extensions/dependency_injection.dart';

/// A builder abstraction for configuring SignalR object instances.
abstract class SignalRBuilder {
  /// Gets the builder service collection.
  ServiceCollection get services;
}
