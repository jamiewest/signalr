import 'cancel_invocation_message.dart';
import 'close_message.dart';
import 'completion_message.dart';
import 'hub_method_invocation_message.dart';
import 'hub_protocol_constants.dart';
import 'ping_message.dart';
import 'stream_item_message.dart';

/// Defines the type of a Hub Message.
enum MessageType {
  /// Indicates the message is an Invocation message and
  /// implements the [InvocationMessage] interface.
  invocation(invocationMessageType, 'Invocation'),

  /// Indicates the message is a StreamItem message and
  /// implements the [StreamItemMessage] interface.
  streamItem(streamItemMessageType, 'StreamItem'),

  /// Indicates the message is a Completion message and
  /// implements the [CompletionMessage] interface.
  completion(completionMessageType, 'Completion'),

  /// Indicates the message is a Stream Invocation message
  /// and implements the [StreamInvocationMessage] interface.
  streamInvocation(streamInvocationMessageType, 'StreamInvocation'),

  /// Indicates the message is a Cancel Invocation message
  /// and implements the [CancelInvocationMessage] interface.
  cancelInvocation(cancelInvocationMessageType, 'CancelInvocation'),

  /// Indicates the message is a Ping message and implements
  /// the [PingMessage] interface.
  ping(pingMessageType, 'Ping'),

  /// Indicates the message is a Close message and implements
  /// the [CloseMessage] interface.
  close(closeMessageType, 'Close');

  final int code;
  final String name;
  const MessageType(
    this.code,
    this.name,
  );

  @override
  String toString() => name;
}
