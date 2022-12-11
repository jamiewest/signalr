import 'package:signalr/src/common/protocol/message_type.dart';

import 'hub_invocation_message.dart';

/// A base class for hub messages representing an invocation.
abstract class HubMethodInvocationMessage extends HubInvocationMessage {
  /// Initializes a new instance of the [HubMethodInvocationMessage] class.
  HubMethodInvocationMessage({
    required super.invocationId,
    required super.type,
    required this.target,
    super.headers,
    this.arguments = const <Object?>[],
    this.streamIds = const <String?>[],
  });

  /// Gets the target method name.
  final String target;

  /// Gets the target method arguments.
  final List<Object?>? arguments;

  /// The target methods stream IDs.
  final List<String?>? streamIds;
}

/// A hub message representing a non-streaming invocation.
class InvocationMessage extends HubMethodInvocationMessage {
  /// Initializes a new instance of the [InvocationMessage] class.
  InvocationMessage({
    required super.invocationId,
    required super.target,
    super.headers,
    super.arguments,
    super.streamIds,
  }) : super(type: MessageType.invocation);

  @override
  String toString() {
    String args;
    String streamIds;

    try {
      args = arguments == null
          ? ''
          : arguments!.map((e) => e?.toString()).join(', ');
    } on Exception catch (ex) {
      args = 'Error: ${ex.toString()}';
    }

    try {
      streamIds = this.streamIds != null
          ? this.streamIds!.map((id) => id?.toString()).join(', ')
          : '';
    } on Exception catch (ex) {
      streamIds = 'Error: ${ex.toString()}';
    }

    return 'InvocationMessage {{ InvocationId: \'$invocationId\', Target: \'$target\', Arguments: [ $args ], StreamIds: [ $streamIds ] }}';
  }
}

/// A hub message representing a streaming invocation.
class StreamInvocationMessage extends HubMethodInvocationMessage {
  /// Initializes a new instance of the [StreamInvocationMessage] class.
  StreamInvocationMessage({
    required super.invocationId,
    required super.target,
    super.headers,
    super.arguments,
    super.streamIds,
  }) : super(type: MessageType.streamInvocation);

  @override
  String toString() {
    String args;
    String streamIds;

    try {
      args = arguments == null
          ? ''
          : arguments!.map((e) => e?.toString()).join(', ');
    } on Exception catch (ex) {
      args = 'Error: ${ex.toString()}';
    }

    try {
      streamIds = this.streamIds != null
          ? this.streamIds!.map((id) => id?.toString()).join(', ')
          : '';
    } on Exception catch (ex) {
      streamIds = 'Error: ${ex.toString()}';
    }

    return 'StreamInvocation {{ InvocationId: \'$invocationId\', Target: \'$target\', Arguments: [ $args ], StreamIds: [ $streamIds ] }}';
  }
}
