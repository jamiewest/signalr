import 'dart:typed_data';

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
  HubMessage? parseMessage(Uint8List input);

  /// Writes the specified [HubMessage] to a writer.
  void writeMessage(HubMessage message, BytesBuilder output);

  /// Converts the specified [HubMessage] to its serialized representation.
  Uint8List getMessageBytes(HubMessage message);

  /// Gets a value indicating whether the protocol supports the
  /// specified version.
  bool isVersionSupported(int version);
}
