import 'package:extensions/dependency_injection.dart';
import 'package:extensions/logging.dart';

import '../core/hub_connection.dart';
import '../core/hub_connection_builder.dart';
import '../core/internal/default_retry_policy.dart';
import '../core/retry_policy.dart';

/// Extension methods for [HubConnectionBuilder].
extension HubConnectionBuilderExtensions on HubConnectionBuilder {
  /// Adds a delegate for configuring the provided [LoggingBuilder].
  /// This may be called multiple times.
  HubConnectionBuilder configureLogging(
    void Function(LoggingBuilder builder) configure,
  ) {
    services.addLogging(configure);
    return this;
  }

  /// Configures the [HubConnection] to automatically attempt to reconnect
  /// if the connection is lost.
  HubConnectionBuilder withAutomaticReconnect([RetryPolicy? retryPolicy]) {
    services.addSingletonInstance<RetryPolicy>(
      retryPolicy ?? DefaultRetryPolicy(),
    );
    return this;
  }

//   /// Configures the [HubConnection] to use HTTP-based transports to connect
//   /// to the specified URL and transports.
//   HubConnectionBuilder withUrl(
//     Uri url,
//     Iterable<HttpTransportType>? transports,
//     Function(HttpConnectionOptions options)? configureHttpConnection,
//   ) {
//     services.configure(HttpConnectionOptions.new, (o) {
//       o.url = url;
//       if (transports != null) {
//         o.transports = transports;
//       }
//     });

//     if (configureHttpConnection != null) {
//       //services.configure(configureHttpConnection);
//     }

//     // Add HttpConnectionOptionsDerivedHttpEndPoint so HubConnection can
//     // read the Url from HttpConnectionOptions without the Signal.Client.Core
//     // project taking a new dependency on Http.Connections.Client.
//     services
//       ..addSingleton<EndPoint>(
//         (services) => HttpConnectionOptionsDerivedHttpEndPoint(
//           httpConnectionOptions:
//               services.getRequiredService<Options<HttpConnectionOptions>>(),
//         ),
//       )
//       ..addSingleton<ConfigureOptions<HttpConnectionOptions>>(
//         (services) => HubProtocolDerivedHttpOptionsConfigurer(
//           services.getRequiredService<HubProtocol>(),
//         ),
//       )
//       ..addSingleton<ConnectionFactory>(
//         (services) => HttpConnectionFactory(
//           services.getRequiredService<Options<HttpConnectionOptions>>(),
//           services.getRequiredService<LoggerFactory>(),
//         ),
//       );

//     return this;
//   }
// }

// class HttpConnectionOptionsDerivedHttpEndPoint extends UriEndPoint {
//   HttpConnectionOptionsDerivedHttpEndPoint({
//     required Options<HttpConnectionOptions> httpConnectionOptions,
//   }) : super(
//           uri: httpConnectionOptions.value!.url!,
//         );
// }

// class HubProtocolDerivedHttpOptionsConfigurer
//     extends ConfigureNamedOptions<HttpConnectionOptions> {
//   final TransferFormat _defaultTransferFormat;

//   HubProtocolDerivedHttpOptionsConfigurer(HubProtocol hubProtocol)
//       : _defaultTransferFormat = hubProtocol.transferFormat;

//   @override
//   void configure(HttpConnectionOptions options) {
//     options.defaultTransferFormat = _defaultTransferFormat;
//   }

//   @override
//   void configureNamed(String name, HttpConnectionOptions options) {
//     configure(options);
//   }
}
