import 'dart:async';
import 'dart:convert';

import 'package:async/async.dart';
import 'package:signalr/src/common/signalr_common/protocol/hub_message.dart';
import 'package:signalr/src/common/signalr_common/protocol/message_type.dart';
import 'package:signalr/src/common/common/protocol/json/json_invocation_extensions.dart';
import 'package:signalr/src/common/signalr_common/protocol/ping_message.dart';
import 'package:signalr/src/common/shared/text_message_formatter.dart';
import 'package:stream_channel/stream_channel.dart';

void main() {
  final controller = StreamChannelController<HubMessage>();
  //controller.local.transform<HubMessage>(jsonHubMessageTransformer);

  controller.foreign.stream.listen((e) => print(e.toString()));
  controller.local.stream.listen((e) => print(e.toString()));

  controller.local.sink.add(PingMessage());
  controller.foreign.sink.add(PingMessage());
}

final StreamChannelTransformer<HubMessage?, List<int>>
    jsonHubMessageTransformer = const _JsonDocument();

class _JsonDocument
    implements StreamChannelTransformer<HubMessage?, List<int>> {
  const _JsonDocument();

  @override
  StreamChannel<HubMessage?> bind(StreamChannel<List<int>> channel) {
    // Convert List<int> -> HubMessage
    final controller = StreamController<HubMessage>();

    var stream = channel.stream.listen((event) {
      final result = utf8.decode(event);
      final messages = TextMessageFormat.parse(result);

      List<HubMessage> hubMessages = <HubMessage>[];

      for (var message in messages) {
        final jsonData = json.decode(message);

        final messageType =
            _getMessageTypeFromJson(jsonData as Map<String, dynamic>);
        HubMessage? parsedMessage;

        switch (messageType) {
          // case MessageType.invocation:
          //   parsedMessage = InvocationMessageExtensions.fromJson(jsonData);
          //   _isInvocationMessage(parsedMessage as InvocationMessage);
          //   break;
          // case MessageType.streamItem:
          //   parsedMessage = StreamItemMessageExtensions.fromJson(jsonData);
          //   _isStreamItemMessage(parsedMessage as StreamItemMessage);
          //   break;
          // case MessageType.completion:
          //   parsedMessage = CompletionMessageExtensions.fromJson(jsonData);
          //   _isCompletionMessage(parsedMessage as CompletionMessage);
          //   break;
          case MessageType.ping:
            parsedMessage = PingMessageExtensions.fromJson(jsonData);
            // Single value, no need to validate
            break;
          // case MessageType.close:
          //   parsedMessage = CloseMessageExtensions.fromJson(jsonData);
          //   // All optional values, no need to validate
          //   break;
          default:
            // Future protocol changes can add message types, old clients can ignore them
            // logging!(
            //     LogLevel.information,
            //     'Unknown message type \'' +
            //         messageType.toString() +
            //         '\' ignored.');
            continue;
        }
        hubMessages.add(parsedMessage);
      }

      for (var hubMessage in hubMessages) {
        controller.sink.add(hubMessage);
      }
    });

    var sink = StreamSinkTransformer<HubMessage, List<int>>.fromHandlers(
      handleData: (data, sink) {
        // Convert HubMessage -> List<int>

        String? jsonValue;

        switch (data.type) {
          case MessageType.undefined:
            break;
          case MessageType.invocation:
          // return TextMessageFormat.write(
          //     json.encode((message as InvocationMessage).toJson()));
          case MessageType.streamItem:
          // return TextMessageFormat.write(
          //     json.encode((message as StreamItemMessage).toJson()));
          case MessageType.completion:
          // return TextMessageFormat.write(
          //     json.encode((message as CompletionMessage).toJson()));
          case MessageType.streamInvocation:
          // return TextMessageFormat.write(
          //     json.encode((message as StreamInvocationMessage).toJson()));
          case MessageType.cancelInvocation:
          // return TextMessageFormat.write(
          //     json.encode((message as CancelInvocationMessage).toJson()));
          case MessageType.ping:
            jsonValue = TextMessageFormat.write(
              json.encode((data as PingMessage).toJson()),
            );
            break;
          case MessageType.close:
          // return TextMessageFormat.write(
          //     json.encode((message as CloseMessage).toJson()));
          default:
            break;
        }

        final value = json.encode(jsonValue);

        final encodedValue = utf8.encode(value);

        sink.add(encodedValue);
      },
    ).bind(channel.sink);

    return StreamChannel.withCloseGuarantee(controller.stream, sink);
  }

  static MessageType _getMessageTypeFromJson(Map<String, dynamic> json) {
    switch (json['type'] as int?) {
      case 0:
        return MessageType.undefined;
      case 1:
        return MessageType.invocation;
      case 2:
        return MessageType.streamItem;
      case 3:
        return MessageType.completion;
      case 4:
        return MessageType.streamInvocation;
      case 5:
        return MessageType.cancelInvocation;
      case 6:
        return MessageType.ping;
      case 7:
        return MessageType.close;
      default:
        return MessageType.undefined;
    }
  }
}
