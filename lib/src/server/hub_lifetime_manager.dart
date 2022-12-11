import 'package:extensions/primitives.dart';

import 'hub.dart';
import 'hub_connection_context.dart';

/// A lifetime manager abstraction for [Hub] instances.
abstract class HubLifetimeManager {
  /// Called when a connection is started.
  Future<void> onConnected(HubConnectionContext connection);

  /// Called when a connection is finished.
  Future<void> onDisconnected(HubConnectionContext connection);

  /// Sends an invocation message to all hub connections.
  Future<void> sendAll(
    String methodName,
    List<Object>? args,
    CancellationToken cancellationToken,
  );

  /// Sends an invocation message to all hub connections excluding the
  /// specified connections.
  Future<void> sendAllExcept(
    String methodName,
    List<Object>? args,
    List<String> excludedConnectionIds,
    CancellationToken cancellationToken,
  );

  /// Sends an invocation message to the specified connection.
  Future<void> sendConnection(
    String connectionId,
    String methodName,
    List<Object>? args,
    CancellationToken cancellationToken,
  );

  /// Sends an invocation message to the specified connections.
  Future<void> sendConnections(
    List<String> connectionIds,
    String methodName,
    List<Object>? args,
    CancellationToken cancellationToken,
  );

  /// Sends an invocation message to the specified group.
  Future<void> sendGroup(
    String groupName,
    String methodName,
    List<Object>? args,
    CancellationToken cancellationToken,
  );

  /// Sends an invocation message to the specified groups.
  Future<void> sendGroups(
    List<String> groupNames,
    String methodName,
    List<Object>? args,
    CancellationToken cancellationToken,
  );

  /// Sends an invocation message to the specified group excluding
  /// the specified connections.
  Future<void> sendGroupExcept(
    String groupName,
    String methodName,
    List<Object>? args,
    List<String> excludedConnectionIds,
    CancellationToken cancellationToken,
  );

  /// Sends an invocation message to the specified user.
  Future<void> sendUser(
    String userId,
    String methodName,
    List<Object>? args,
    CancellationToken cancellationToken,
  );

  /// Sends an invocation message to the specified users.
  Future<void> sendUsers(
    List<String> userIds,
    String methodName,
    List<Object>? args,
    CancellationToken cancellationToken,
  );

  /// Adds a connection to the specified group.
  Future<void> addToGroup(
    String connectionId,
    String groupName,
    CancellationToken cancellationToken,
  );

  /// Removes a connection from the specified group.
  Future<void> removeFromGroup(
    String connectionId,
    String groupName,
    CancellationToken cancellationToken,
  );
}
