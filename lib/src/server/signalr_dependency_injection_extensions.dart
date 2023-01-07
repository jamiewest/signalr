import 'package:extensions/dependency_injection.dart';

import 'signalr_server_builder.dart';

/// Extension methods for [ServiceCollection].
extension SignalRDependencyInjectionExtensions on ServiceCollection {
  /// Adds the minimum essential SignalR services to the specified
  /// [ServiceCollection]. Additional services must be added separately
  /// using the [SignalRServerBuilder] returned from this method.
  SignalRServerBuilder addSignalRCore() {
    final builder = SignalRServerBuilder(this);

    return builder;
  }
}
