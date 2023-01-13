import 'package:extensions/logging.dart';

import 'hub_connection_context.dart';
import 'hub_connection_store.dart';
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
    throw UnimplementedError();
  }

  @override
  Future<void> onDisconnected(HubConnectionContext connection) {
    throw UnimplementedError();
  }

  @override
  Future<void> removeFromGroup(String connectionId, String groupName,
      CancellationToken cancellationToken) {
    throw UnimplementedError();
  }

  @override
  Future<void> sendAll(String methodName, List<Object>? args,
      CancellationToken cancellationToken) {
    throw UnimplementedError();
  }

  @override
  Future<void> sendAllExcept(String methodName, List<Object>? args,
      List<String> excludedConnectionIds, CancellationToken cancellationToken) {
    throw UnimplementedError();
  }

  @override
  Future<void> sendConnection(String connectionId, String methodName,
      List<Object>? args, CancellationToken cancellationToken) {
    throw UnimplementedError();
  }

  @override
  Future<void> sendConnections(List<String> connectionIds, String methodName,
      List<Object>? args, CancellationToken cancellationToken) {
    throw UnimplementedError();
  }

  @override
  Future<void> sendGroup(String groupName, String methodName,
      List<Object>? args, CancellationToken cancellationToken) {
    throw UnimplementedError();
  }

  @override
  Future<void> sendGroupExcept(
      String groupName,
      String methodName,
      List<Object>? args,
      List<String> excludedConnectionIds,
      CancellationToken cancellationToken) {
    throw UnimplementedError();
  }

  @override
  Future<void> sendGroups(List<String> groupNames, String methodName,
      List<Object>? args, CancellationToken cancellationToken) {
    throw UnimplementedError();
  }

  @override
  Future<void> sendUser(String userId, String methodName, List<Object>? args,
      CancellationToken cancellationToken) {
    throw UnimplementedError();
  }

  @override
  Future<void> sendUsers(List<String> userIds, String methodName,
      List<Object>? args, CancellationToken cancellationToken) {
    throw UnimplementedError();
  }
}
