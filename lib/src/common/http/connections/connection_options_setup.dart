import 'package:extensions/options.dart';

import 'connection_options.dart';

/// Sets up [ConnectionOptions].
class ConnectionOptionsSetup implements ConfigureOptions<ConnectionOptions> {
  /// Default timeout value for disconnecting idle connections.
  static Duration defaultDisconnectTimeout = const Duration(seconds: 15);

  /// Sets default values for options if they have not been set yet.
  @override
  void configure(ConnectionOptions options) {
    if (options.disconnectTimeout == null) {
      options.disconnectTimeout = defaultDisconnectTimeout;
    }
  }
}
