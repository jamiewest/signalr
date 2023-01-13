import '../signalr_common/protocol/cancel_invocation_message.dart';
import '../signalr_common/protocol/close_message.dart';
import '../signalr_common/protocol/completion_message.dart';
import '../signalr_common/protocol/hub_method_invocation_message.dart';
import '../signalr_common/protocol/ping_message.dart';
import '../signalr_common/protocol/stream_item_message.dart';

extension InvocationMessageExtensions on InvocationMessage {
  InvocationMessage fromJson(Map<String, dynamic> json) => InvocationMessage(
        target: json['target'] as String,
        arguments: json['arguments'] as List?,
        headers: json['headers'] as Map<String, String>?,
        invocationId: json['invocationId'] as String?,
        streamIds: json['streamIds'] as List<String>?,
      );

  Map<String, dynamic> toJson() => {
        'type': type?.code.toString(),
        if (invocationId != null) 'invocationId': invocationId,
        'target': target,
        'arguments': arguments ?? [],
        if (streamIds != null) 'streamIds': streamIds
      };
}

extension StreamInvocationMessageExtensions on StreamInvocationMessage {
  Map<String, dynamic> toJson() => {
        'type': type?.code.toString(),
        'invocationId': invocationId,
        'target': target,
        'arguments': arguments,
        'streamIds': streamIds
      };
}

extension StreamItemMessageExtensions on StreamItemMessage {
  static StreamItemMessage fromJson(Map<String, dynamic> json) =>
      StreamItemMessage(
        item: json['item'] as dynamic,
        //headers: json['headers'] as Map<String, String>?,
        invocationId: json['invocationId'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'type': type?.code.toString(),
        'item': item,
        'invocationId': invocationId,
      };
}

extension CancelInvocationMessageExtensions on CancelInvocationMessage {
  Map<String, dynamic> toJson() => {
        'type': type?.code.toString(),
        'invocationId': invocationId,
      };
}

extension CompletionMessageExtensions on CompletionMessage {
  static CompletionMessage fromJson(Map<String, dynamic> json) =>
      CompletionMessage(
        result: json['result'],
        error: json['error'] as String?,
        //headers: json['headers'] as Map<String, String>?,
        invocationId: json['invocationId'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'type': type?.code.toString(),
        'invocationId': invocationId,
        'result': result,
        'error': error,
      };
}

extension PingMessageExtensions on PingMessage {
  static PingMessage fromJson(Map<String, dynamic> json) => PingMessage();

  Map<String, dynamic> toJson() => {
        'type': type?.code.toString(),
      };
}

extension CloseMessageExtensions on CloseMessage {
  static CloseMessage fromJson(Map<String, dynamic> json) =>
      CloseMessage(error: json['error'] as String?);

  Map<String, dynamic> toJson() => {
        'type': type?.code.toString(),
        'error': error,
      };
}
