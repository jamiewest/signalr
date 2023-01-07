import 'package:extensions/dependency_injection.dart';

import '../signalr_common/protocol/hub_protocol.dart';
import '../signalr_common/signalr_builder.dart';

import 'protocol/json_hub_protocol.dart';

/// Extension methods for [SignalRBuilder].
extension JsonProtocolDependencyInjectionExtensions on SignalRBuilder {
  /// Enables the JSON protocol for SignalR.
  SignalRBuilder addJsonProtocol() {
    services.tryAddIterable(
      ServiceDescriptor.singleton<HubProtocol>((services) => JsonHubProtocol()),
    );
    return this;
  }
}
