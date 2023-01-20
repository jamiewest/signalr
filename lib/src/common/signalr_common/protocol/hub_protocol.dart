import 'hub_message.dart';
import 'transfer_format.dart';

/// A protocol abstraction for communicating with SignalR hubs.
abstract class HubProtocol {
  /// Gets the name of the protocol. The name is used by SignalR to
  /// resolve the protocol between the client and server.
  String get name;

  /// Gets the major version of the protocol.
  int get version;

  /// Gets the transfer format of the protocol.
  TransferFormat get transferFormat;

  /// Creates a new [HubMessage] from the specified serialized representation.
  List<HubMessage> parseMessage(List<int> input);

  /// Returns the specified [HubMessage] as a serialized representation.
  List<int> writeMessage(HubMessage message);

  /// Gets a value indicating whether the protocol supports the
  /// specified version.
  bool isVersionSupported(int version);
}
