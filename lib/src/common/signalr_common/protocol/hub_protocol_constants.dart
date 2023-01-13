import 'message_type.dart';

/// Represents the invocation message type.
const int invocationMessageType = 1;

/// Represents the stream item message type.
const int streamItemMessageType = 2;

/// Represents the completion message type.
const int completionMessageType = 3;

/// Represents the stream invocation message type.
const int streamInvocationMessageType = 4;

/// Represents the cancel invocation message type.
const int cancelInvocationMessageType = 5;

/// Represents the ping message type.
const int pingMessageType = 6;

/// Represents the close message type.
const int closeMessageType = 7;

MessageType getMessageTypeByValue(int value) {
  switch (value) {
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
      throw Exception('Invalid message type.');
  }
}
