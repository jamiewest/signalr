import 'dart:convert';

import '../../shared/text_message_formatter.dart';
import '../../signalr_common/protocol/hub_message.dart';
import '../../signalr_common/protocol/hub_protocol.dart';
import '../../signalr_common/protocol/message_type.dart';
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
    final decodedUtf8 = utf8.decode(input);

    final hubMessages = <HubMessage>[];
    final messages = TextMessageFormat.parse(decodedUtf8);
    for (var message in messages) {
      final decodedJson = json.decode(message);
    }
  }

  @override
  List<int> writeMessage(HubMessage message) {
    throw UnimplementedError();
  }
}
