import 'package:extensions/dependency_injection.dart';
import '../hub_lifetime_manager.dart';

/// A manager abstraction for adding and removing connections from groups.
class GroupManager {
  final HubLifetimeManager _lifetimeManager;

  const GroupManager(HubLifetimeManager lifetimeManager)
      : _lifetimeManager = lifetimeManager;

  /// Adds a connection to the specified group.
  Future<void> addToGroupAsync(
    String connectionId,
    String groupName,
    CancellationToken cancellationToken,
  ) =>
      _lifetimeManager.addToGroup(
        connectionId,
        groupName,
        cancellationToken,
      );

  /// Removes a connection from the specified group.
  Future<void> removeFromGroupAsync(
    String connectionId,
    String groupName,
    CancellationToken cancellationToken,
  ) =>
      _lifetimeManager.removeFromGroup(
        connectionId,
        groupName,
        cancellationToken,
      );
}
