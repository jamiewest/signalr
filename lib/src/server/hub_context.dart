import 'hub_clients.dart';
import 'hub_lifetime_manager.dart';
import 'internal/group_manager.dart';

/// A context abstraction for a hub.
class HubContext {
  final HubClients _clients;
  final GroupManager _groups;

  HubContext({
    required HubLifetimeManager lifetimeManager,
  })  : _clients = HubClients(lifetimeManager),
        _groups = GroupManager(lifetimeManager);

  /// Gets a [HubClients] that can be used to invoke methods on
  /// clients connected to the hub.
  HubClients get clients => _clients;

  /// Gets a [GroupManager] that can be used to add and remove
  /// connections to named groups.
  GroupManager get groups => _groups;
}
