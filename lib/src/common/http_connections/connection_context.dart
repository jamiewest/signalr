import 'package:extensions/configuration.dart';
import 'package:stream_channel/stream_channel.dart';

/// Encapsulates all information about an individual connection.
abstract class ConnectionContext extends AsyncDisposable {
  /// Gets or sets a unique identifier to represent
  /// this connection in trace logs.
  String? connectionId;

  /// Gets or sets the [StreamChannel] that can be used to
  /// read or write data on this connection.
  StreamChannel<List<int>>? transport;
}
