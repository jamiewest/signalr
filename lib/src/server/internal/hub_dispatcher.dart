import 'package:signalr/src/common/signalr_common/protocol/hub_message.dart';
import 'package:signalr/src/server/hub_connection_context.dart';

abstract class HubDispatcher {
  Future<void> onConnected(HubConnectionContext connection);
  Future<void> onDisconnect(
    HubConnectionContext connection,
    Exception? exception,
  );
  Future<void> dispatchMessage(
    HubConnectionContext connection,
    HubMessage hubMessage,
  );
}
