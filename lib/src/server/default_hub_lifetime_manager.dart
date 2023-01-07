import 'package:extensions/logging.dart';
import 'package:signalr/src/server/hub_connection_context.dart';

import 'package:extensions/src/primitives/cancellation_token.dart';
import 'package:signalr/src/server/hub_connection_store.dart';

import 'hub_lifetime_manager.dart';

class DefaultHubLifetimeManager extends HubLifetimeManager {
  final HubConnectionStore _connections = HubConnectionStore();
  final Logger _logger;
  DefaultHubLifetimeManager(Logger logger) : _logger = logger;

  @override
  Future<void> addToGroup(
    String connectionId,
    String groupName,
    CancellationToken cancellationToken,
  ) {
    final connection = _connections[connectionId];
    if (connection == null) {
      return Future.value();
    }

    return Future.value();
  }

  @override
  Future<void> onConnected(HubConnectionContext connection) {
    // TODO: implement onConnected
    throw UnimplementedError();
  }

  @override
  Future<void> onDisconnected(HubConnectionContext connection) {
    // TODO: implement onDisconnected
    throw UnimplementedError();
  }

  @override
  Future<void> removeFromGroup(String connectionId, String groupName,
      CancellationToken cancellationToken) {
    // TODO: implement removeFromGroup
    throw UnimplementedError();
  }

  @override
  Future<void> sendAll(String methodName, List<Object>? args,
      CancellationToken cancellationToken) {
    // TODO: implement sendAll
    throw UnimplementedError();
  }

  @override
  Future<void> sendAllExcept(String methodName, List<Object>? args,
      List<String> excludedConnectionIds, CancellationToken cancellationToken) {
    // TODO: implement sendAllExcept
    throw UnimplementedError();
  }

  @override
  Future<void> sendConnection(String connectionId, String methodName,
      List<Object>? args, CancellationToken cancellationToken) {
    // TODO: implement sendConnection
    throw UnimplementedError();
  }

  @override
  Future<void> sendConnections(List<String> connectionIds, String methodName,
      List<Object>? args, CancellationToken cancellationToken) {
    // TODO: implement sendConnections
    throw UnimplementedError();
  }

  @override
  Future<void> sendGroup(String groupName, String methodName,
      List<Object>? args, CancellationToken cancellationToken) {
    // TODO: implement sendGroup
    throw UnimplementedError();
  }

  @override
  Future<void> sendGroupExcept(
      String groupName,
      String methodName,
      List<Object>? args,
      List<String> excludedConnectionIds,
      CancellationToken cancellationToken) {
    // TODO: implement sendGroupExcept
    throw UnimplementedError();
  }

  @override
  Future<void> sendGroups(List<String> groupNames, String methodName,
      List<Object>? args, CancellationToken cancellationToken) {
    // TODO: implement sendGroups
    throw UnimplementedError();
  }

  @override
  Future<void> sendUser(String userId, String methodName, List<Object>? args,
      CancellationToken cancellationToken) {
    // TODO: implement sendUser
    throw UnimplementedError();
  }

  @override
  Future<void> sendUsers(List<String> userIds, String methodName,
      List<Object>? args, CancellationToken cancellationToken) {
    // TODO: implement sendUsers
    throw UnimplementedError();
  }
}
