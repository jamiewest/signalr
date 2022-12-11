import 'package:extensions/dependency_injection.dart';
import 'package:extensions/logging.dart';
import 'package:signalr/src/client/hub_connection_builder.dart';
import 'package:signalr/src/client/internal/default_retry_policy.dart';
import 'package:signalr/src/client/retry_policy.dart';

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
}
