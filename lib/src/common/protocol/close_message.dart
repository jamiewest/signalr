import 'package:signalr/src/common/protocol/message_type.dart';

import 'hub_message.dart';

/// The message sent when closing a connection.
class CloseMessage extends HubMessage {
  /// Initializes a new instance of the [CloseMessage] class with an
  /// optional error message and a [bool] indicating whether or not a
  /// client with automatic reconnects enabled should attempt to reconnect
  /// upon receiving the message.
  const CloseMessage({
    this.error,
    this.allowReconnect = false,
  }) : super(type: MessageType.close);

  /// Gets the optional error message.
  final String? error;

  /// If `false`, clients with automatic reconnects enabled should not
  /// attempt to automatically reconnect after receiving the [CloseMessage].
  final bool allowReconnect;

  /// An empty close message with no error and [allowReconnect] set to `false`.
  static CloseMessage get empty => const CloseMessage(
        error: null,
        allowReconnect: false,
      );
}
