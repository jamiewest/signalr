import 'package:extensions/dependency_injection.dart';

import 'hub.dart';
import 'hub_caller_context.dart';

/// Context for the hub lifetime events [Hub.onConnectedAsync]
/// and [Hub.onDisconnectedAsync].
class HubLifetimeContext {
  /// Instantiates a new instance of the [HubLifetimeContext] class.
  const HubLifetimeContext(
    this.context,
    this.hub,
    this.serviceProvider,
  );

  /// Gets the context for the active Hub connection and caller.
  final HubCallerContext context;

  /// Gets the Hub instance.
  final Hub hub;

  /// The [ServiceProvider] specific to the scope of this Hub
  /// method invocation.
  final ServiceProvider serviceProvider;
}
