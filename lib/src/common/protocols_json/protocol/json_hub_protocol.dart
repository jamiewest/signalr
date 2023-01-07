import '../../signalr_common/protocol/hub_message.dart';
import '../../signalr_common/protocol/hub_protocol.dart';
import '../../signalr_common/protocol/transfer_format.dart';

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
  HubMessage? parseMessage(List<int> input) {
    throw UnimplementedError();
  }

  @override
  List<int> writeMessage(HubMessage message) {
    throw UnimplementedError();
  }
}
