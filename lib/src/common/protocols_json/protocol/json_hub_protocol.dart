import 'dart:convert';

import '../../shared/text_message_formatter.dart';
import '../../signalr_common/protocol/cancel_invocation_message.dart';
import '../../signalr_common/protocol/close_message.dart';
import '../../signalr_common/protocol/completion_message.dart';
import '../../signalr_common/protocol/hub_message.dart';
import '../../signalr_common/protocol/hub_method_invocation_message.dart';
import '../../signalr_common/protocol/hub_protocol.dart';
import '../../signalr_common/protocol/message_type.dart';
import '../../signalr_common/protocol/ping_message.dart';
import '../../signalr_common/protocol/stream_item_message.dart';
import '../../signalr_common/protocol/transfer_format.dart';
import '../json_invocation_extensions.dart';

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
  List<HubMessage> parseMessage(List<int> input) {
    final decodedUtf8 = utf8.decode(input);

    final hubMessages = <HubMessage>[];
    final messages = TextMessageFormat.parse(decodedUtf8);
    for (var message in messages) {
      final decodedJson = json.decode(message) as Map<String, dynamic>;
      final value = decodedJson['type'] as int?;
      if (value == null) {
        return [];
      }
      final messageType = MessageType.from(value);

      HubMessage? parsedMessage;

      switch (messageType) {
        case MessageType.invocation:
          parsedMessage = _invocationMessage(decodedJson);
          break;
        case MessageType.streamItem:
          parsedMessage = _streamItemMessage(decodedJson);
          break;
        case MessageType.completion:
          parsedMessage = _completionMessage(decodedJson);
          break;
        case MessageType.ping:
          parsedMessage = const PingMessage();
          break;
        case MessageType.close:
          parsedMessage = _closeMessage(decodedJson);
          break;
        default:
          continue;
      }

      hubMessages.add(parsedMessage);
    }

    return hubMessages;
  }

  @override
  List<int> writeMessage(HubMessage message) {
    switch (message.type) {
      case MessageType.invocation:
        final jsonMessage = (message as InvocationMessage).toJson();
        final value = TextMessageFormat.write(json.encode(jsonMessage));
        return utf8.encode(value);

      case MessageType.streamItem:
        final jsonMessage = (message as StreamItemMessage).toJson();
        final value = TextMessageFormat.write(json.encode(jsonMessage));
        return utf8.encode(value);

      case MessageType.completion:
        final jsonMessage = (message as CompletionMessage).toJson();
        final value = TextMessageFormat.write(json.encode(jsonMessage));
        return utf8.encode(value);

      case MessageType.streamInvocation:
        final jsonMessage = (message as StreamInvocationMessage).toJson();
        final value = TextMessageFormat.write(json.encode(jsonMessage));
        return utf8.encode(value);

      case MessageType.cancelInvocation:
        final jsonMessage = (message as CancelInvocationMessage).toJson();
        final value = TextMessageFormat.write(json.encode(jsonMessage));
        return utf8.encode(value);

      case MessageType.ping:
        final jsonMessage = (message as PingMessage).toJson();
        final value = TextMessageFormat.write(json.encode(jsonMessage));
        return utf8.encode(value);

      case MessageType.close:
        final jsonMessage = (message as CloseMessage).toJson();
        final value = TextMessageFormat.write(json.encode(jsonMessage));
        return utf8.encode(value);

      default:
        break;
    }

    return [];
  }

  InvocationMessage _invocationMessage(Map<String, dynamic> json) =>
      InvocationMessage(
        target: json['target'] as String? ?? '',
        arguments: json['arguments'] as List?,
        headers: json['headers'] as Map<String, String>?,
        invocationId: json['invocationId'] as String?,
        streamIds: json['streamIds'] as List<String>?,
      );

  StreamItemMessage _streamItemMessage(Map<String, dynamic> json) =>
      StreamItemMessage(
        item: json['item'] as dynamic,
        headers: json['headers'] as Map<String, String>?,
        invocationId: json['invocationId'] as String?,
      );

  CompletionMessage _completionMessage(Map<String, dynamic> json) =>
      CompletionMessage(
        result: json['result'],
        error: json['error'] as String?,
        headers: json['headers'] as Map<String, String>?,
        invocationId: json['invocationId'] as String?,
      );

  CloseMessage _closeMessage(Map<String, dynamic> json) =>
      CloseMessage(error: json['error'] as String?);
}
