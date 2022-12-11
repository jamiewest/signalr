import 'package:extensions/dependency_injection.dart';
import 'package:signalr/src/common/protocol/hub_protocol.dart';
import 'package:signalr/src/common/protocol/json/json_hub_protocol.dart';
import 'package:signalr/src/common/signalr_builder.dart';

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
