import 'package:extensions/configuration.dart';

import '../shared/duplex_pipe.dart';

/// Encapsulates all information about an individual connection.
abstract class ConnectionContext extends AsyncDisposable {
  /// Gets or sets a unique identifier to represent
  /// this connection in trace logs.
  String? connectionId;

  /// Gets or sets the [DuplexPipe] that can be used to
  /// read or write data on this connection.
  DuplexPipe? transport;
}
