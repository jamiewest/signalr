import 'client_proxy.dart';
import 'hub_lifetime_manager.dart';
import 'proxies.dart';

/// Provides access to client connections.
class HubClients {
  final HubLifetimeManager _lifetimeManager;

  HubClients(HubLifetimeManager lifetimeManager)
      : _lifetimeManager = lifetimeManager,
        all = AllClientProxy(lifetimeManager: lifetimeManager);

  final ClientProxy all;

  ClientProxy allExcept(List<String> excludedConnectionIds) => AllClientProxy(
        lifetimeManager: _lifetimeManager,
        excludedConnectionIds: excludedConnectionIds,
      );

  SingleClientProxy client(String connectionId) => SingleClientProxy(
        lifetimeManager: _lifetimeManager,
        connectionId: connectionId,
      );

  ClientProxy group(String groupName) => GroupProxy(
        lifetimeManager: _lifetimeManager,
        groupName: groupName,
      );

  ClientProxy groupExcept(
    String groupName,
    List<String> excludedConnectionIds,
  ) =>
      GroupExceptProxy(
        lifetimeManager: _lifetimeManager,
        groupName: groupName,
        excludedConnectionIds: excludedConnectionIds,
      );

  ClientProxy clients(List<String> connectionIds) => MultipleClientProxy(
        lifetimeManager: _lifetimeManager,
        connectionIds: connectionIds,
      );

  ClientProxy groups(List<String> groupNames) => MultipleGroupProxy(
        lifetimeManager: _lifetimeManager,
        groupNames: groupNames,
      );

  ClientProxy user(String userId) => UserProxy(
        lifetimeManager: _lifetimeManager,
        userId: userId,
      );

  ClientProxy users(List<String> userIds) => MultipleClientProxy(
        lifetimeManager: _lifetimeManager,
        connectionIds: userIds,
      );
}
