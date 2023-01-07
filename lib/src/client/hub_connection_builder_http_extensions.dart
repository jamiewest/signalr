import 'package:extensions/dependency_injection.dart';
import 'package:extensions/logging.dart';
import 'package:extensions/options.dart';

import '../common/http_connections/connection_factory.dart';
import '../common/http_connections_common/end_point.dart';
import '../common/http_connections_common/uri_end_point.dart';
import '../common/signalr_common/protocol/hub_protocol.dart';
import '../common/signalr_common/protocol/transfer_format.dart';

import 'core/hub_connection_builder.dart';
import 'http_connections_client/http_connection_factory.dart';
import 'http_connections_client/http_connection_options.dart';

/// Extension methods for [HubConnectionBuilder].
extension HubConnectionBuilderExtensions on HubConnectionBuilder {
  /// Configures the [HubConnection] to use HTTP-based transports to connect
  /// to the specified URL and transports.
  HubConnectionBuilder withUrl(
    Uri url,
    int? transports,
    Function(HttpConnectionOptions options)? configureHttpConnection,
  ) {
    services.configure(() => HttpConnectionOptions(), (o) {
      o.url = url;
      if (transports != null) {
        o.transports = transports;
      }
    });

    if (configureHttpConnection != null) {
      //services.configure(configureHttpConnection);
    }

    // Add HttpConnectionOptionsDerivedHttpEndPoint so HubConnection can
    // read the Url from HttpConnectionOptions without the Signal.Client.Core
    // project taking a new dependency on Http.Connections.Client.
    services.addSingleton<EndPoint>(
      (services) => HttpConnectionOptionsDerivedHttpEndPoint(
        httpConnectionOptions:
            services.getRequiredService<Options<HttpConnectionOptions>>(),
      ),
    );

    // Configure the HttpConnection so that it uses the correct transfer
    // format for the configured HubProtocol.
    services.addSingleton<ConfigureOptions<HttpConnectionOptions>>(
      (services) => HubProtocolDerivedHttpOptionsConfigurer(
        services.getRequiredService<HubProtocol>(),
      ),
    );

    services.addSingleton<ConnectionFactory>(
      (services) => HttpConnectionFactory(
        services.getRequiredService<Options<HttpConnectionOptions>>(),
        services.getRequiredService<LoggerFactory>(),
      ),
    );

    return this;
  }
}

class HttpConnectionOptionsDerivedHttpEndPoint extends UriEndPoint {
  HttpConnectionOptionsDerivedHttpEndPoint({
    required Options<HttpConnectionOptions> httpConnectionOptions,
  }) : super(
          uri: httpConnectionOptions.value!.url!,
        );
}

class HubProtocolDerivedHttpOptionsConfigurer
    extends ConfigureNamedOptions<HttpConnectionOptions> {
  final TransferFormat _defaultTransferFormat;

  HubProtocolDerivedHttpOptionsConfigurer(HubProtocol hubProtocol)
      : _defaultTransferFormat = hubProtocol.transferFormat;

  @override
  void configure(HttpConnectionOptions options) {
    options.defaultTransferFormat = _defaultTransferFormat;
  }

  @override
  void configureNamed(String name, HttpConnectionOptions options) {
    configure(options);
  }
}
