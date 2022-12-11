import 'dart:typed_data';

import '../hub_message.dart';
import '../hub_protocol.dart';
import '../transfer_format.dart';

/// Implements the SignalR Hub Protocol.
class JsonHubProtocol implements HubProtocol {
  final String _protocolName = 'json';
  final int _protocolVersion = 1;

  @override
  String get name => _protocolName;

  @override
  int get version => _protocolVersion;

  @override
  TransferFormat get transferFormat => TransferFormat.text;

  @override
  bool isVersionSupported(int version) => version == this.version;

  @override
  HubMessage? parseMessage(Uint8List input) {
    // TODO: implement parseMessage
    throw UnimplementedError();
  }

  @override
  void writeMessage(HubMessage message, BytesBuilder writer) {
    // TODO: implement writeMessage
  }

  @override
  Uint8List getMessageBytes(HubMessage message) {
    throw UnimplementedError();
  }
}
