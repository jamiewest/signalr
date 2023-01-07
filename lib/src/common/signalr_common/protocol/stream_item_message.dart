import 'package:signalr/src/common/signalr_common/protocol/message_type.dart';

import 'hub_invocation_message.dart';

/// Represents a single item of an active stream.
class StreamItemMessage extends HubInvocationMessage {
  /// Constructs a [StreamItemMessage].
  StreamItemMessage({
    required super.invocationId,
    this.item,
  }) : super(type: MessageType.streamItem);

  /// The single item from a stream.
  final Object? item;

  @override
  String toString() =>
      'StreamItem {{ InvocationId: \'$invocationId\', Item: ${item ?? '<<null>>'} }}';
}
