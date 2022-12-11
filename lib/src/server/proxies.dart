import 'package:extensions/src/primitives/cancellation_token.dart';
import 'package:signalr/src/server/client_proxy.dart';
import 'package:signalr/src/server/hub_lifetime_manager.dart';

class UserProxy implements ClientProxy {
  final String _userId;
  final HubLifetimeManager _lifetimeManager;

  UserProxy({
    required HubLifetimeManager lifetimeManager,
    required String userId,
  })  : _lifetimeManager = lifetimeManager,
        _userId = userId;

  @override
  Future<void> send(
    String method,
    List<Object>? args,
    CancellationToken cancellationToken,
  ) {
    throw UnimplementedError();
  }
}

class MultipleUserProxy implements ClientProxy {
  final List<String> _userId;
  final HubLifetimeManager _lifetimeManager;

  MultipleUserProxy({
    required HubLifetimeManager lifetimeManager,
    required List<String> userId,
  })  : _lifetimeManager = lifetimeManager,
        _userId = userId;

  @override
  Future<void> send(
    String method,
    List<Object>? args,
    CancellationToken cancellationToken,
  ) {
    throw UnimplementedError();
  }
}

class GroupProxy implements ClientProxy {
  final HubLifetimeManager _lifetimeManager;
  final String _groupName;

  GroupProxy({
    required HubLifetimeManager lifetimeManager,
    required String groupName,
  })  : _lifetimeManager = lifetimeManager,
        _groupName = groupName;

  @override
  Future<void> send(
    String method,
    List<Object>? args,
    CancellationToken cancellationToken,
  ) {
    throw UnimplementedError();
  }
}

class MultipleGroupProxy implements ClientProxy {
  final HubLifetimeManager _lifetimeManager;
  final List<String> _groupNames;

  MultipleGroupProxy({
    required HubLifetimeManager lifetimeManager,
    required List<String> groupNames,
  })  : _lifetimeManager = lifetimeManager,
        _groupNames = groupNames;

  @override
  Future<void> send(
    String method,
    List<Object>? args,
    CancellationToken cancellationToken,
  ) {
    throw UnimplementedError();
  }
}

class GroupExceptProxy implements ClientProxy {
  final HubLifetimeManager _lifetimeManager;
  final String _groupName;
  final List<String> _excludedConnectionIds;

  GroupExceptProxy({
    required HubLifetimeManager lifetimeManager,
    required String groupName,
    required List<String> excludedConnectionIds,
  })  : _lifetimeManager = lifetimeManager,
        _groupName = groupName,
        _excludedConnectionIds = excludedConnectionIds;

  @override
  Future<void> send(
    String method,
    List<Object>? args,
    CancellationToken cancellationToken,
  ) {
    throw UnimplementedError();
  }
}

class AllClientProxy implements ClientProxy {
  final HubLifetimeManager _lifetimeManager;
  final List<String>? _excludedConnectionIds;

  AllClientProxy({
    required HubLifetimeManager lifetimeManager,
    List<String>? excludedConnectionIds,
  })  : _lifetimeManager = lifetimeManager,
        _excludedConnectionIds = excludedConnectionIds;

  @override
  Future<void> send(
    String method,
    List<Object>? args,
    CancellationToken cancellationToken,
  ) {
    throw UnimplementedError();
  }
}

class AllClientsExceptProxy implements ClientProxy {
  final HubLifetimeManager _lifetimeManager;
  final List<String> _excludedConnectionIds;

  AllClientsExceptProxy({
    required HubLifetimeManager lifetimeManager,
    required List<String> excludedConnectionIds,
  })  : _lifetimeManager = lifetimeManager,
        _excludedConnectionIds = excludedConnectionIds;

  @override
  Future<void> send(
    String method,
    List<Object>? args,
    CancellationToken cancellationToken,
  ) {
    throw UnimplementedError();
  }
}

class MultipleClientProxy implements ClientProxy {
  final HubLifetimeManager _lifetimeManager;
  final List<String> _connectionIds;

  MultipleClientProxy({
    required HubLifetimeManager lifetimeManager,
    required List<String> connectionIds,
  })  : _lifetimeManager = lifetimeManager,
        _connectionIds = connectionIds;

  @override
  Future<void> send(
    String method,
    List<Object>? args,
    CancellationToken cancellationToken,
  ) {
    throw UnimplementedError();
  }
}

class SingleClientProxy implements ClientProxy {
  final HubLifetimeManager _lifetimeManager;
  final String _connectionId;

  SingleClientProxy({
    required HubLifetimeManager lifetimeManager,
    required String connectionId,
  })  : _lifetimeManager = lifetimeManager,
        _connectionId = connectionId;

  @override
  Future<void> send(
    String method,
    List<Object>? args,
    CancellationToken cancellationToken,
  ) {
    throw UnimplementedError();
  }
}
