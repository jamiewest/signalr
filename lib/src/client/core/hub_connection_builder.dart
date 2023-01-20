import 'package:extensions/dependency_injection.dart';
import 'package:extensions/logging.dart';

import '../../common/http_connections/connection_factory.dart';
import '../../common/http_connections_common/end_point.dart';
import '../../common/signalr_common/protocol/hub_protocol.dart';
import '../../common/signalr_common/signalr_builder.dart';

import 'hub_connection.dart';

/// A builder for configuring [HubConnection] instances.
class HubConnectionBuilder implements SignalRBuilder {
  final ServiceCollection _services;
  bool _hubConnectionBuilt = false;

  /// Initializes a new instance of [HubConnectionBuilder] class.
  HubConnectionBuilder()
      : _services = ServiceCollection()
          ..addSingleton<HubConnection>(
            (services) => HubConnection(
              connectionFactory:
                  services.getRequiredService<ConnectionFactory>(),
              protocol: services.getRequiredService<HubProtocol>(),
              endPoint: services.getRequiredService<EndPoint>(),
              serviceProvider: services,
              loggerFactory: services.getRequiredService<LoggerFactory>(),
            ),
          )
          ..addLogging();

  @override
  ServiceCollection get services => _services;

  /// Creates a [HubConnection].
  HubConnection build() {
    if (_hubConnectionBuilt) {
      throw Exception(
        'HubConnectionBuilder allows creation only of a single instance'
        ' of HubConnection.',
      );
    }
    _hubConnectionBuilt = true;

    // The service provider is disposed by the HubConnection
    final serviceProvider = services.buildServiceProvider();

    final connectionFactory = serviceProvider.getService<ConnectionFactory>();
    if (connectionFactory == null) {
      throw Exception(
        'Cannot create HubConnection instance. An ConnectionFactory'
        ' was not configured.',
      );
    }

    final endPoint = serviceProvider.getService<EndPoint>();
    if (endPoint == null) {
      throw Exception(
        'Cannot create HubConnection instance. An EndPoint was not configured.',
      );
    }

    return serviceProvider.getRequiredService<HubConnection>();
  }
}
