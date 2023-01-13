import '../common/signalr_common/protocol/hub_protocol.dart';

/// A resolver abstraction for working with [HubProtocol] instances.
abstract class HubProtocolResolver {
  /// Gets a collection of all available hub protocols.
  List<HubProtocol> get allProtocols;

  /// Gets the hub protocol with the specified name, if it is allowed
  /// by the specified list of supported protocols.
  HubProtocol? getProtocol(
    String protocolName,
    List<String>? supportedProtocols,
  );
}
