import '../../common/protocol/transfer_format.dart';
import '../../common/http/http_transport_type.dart';

typedef AccessTokenProvider = Future<String?> Function();

/// Options used to configure a [HttpConnection] instance.
class HttpConnectionOptions {
  // Selected because of the number of client connections is usually much
  // lower than server connections and therefore willing to use more memory.
  // We'll default to a maximum of 1MB buffer;
  static const int _defaultBufferSize = 1 * 1024 * 1024;

  HttpConnectionOptions({
    this.transportBufferSize = _defaultBufferSize,
    this.applicationMaxBufferSize = _defaultBufferSize,
    this.url,
    this.transports = 0, // HttpTransportType.none
    this.skipNegotiation = false,
    this.accessTokenProvider,
    this.closeTimeout = const Duration(seconds: 5),
    this.defaultTransferFormat = TransferFormat.binary,
  }) : headers = <String, String>{};

  /// Gets or sets a collection of headers that will be sent with HTTP requests.
  Map<String, String> headers;

  /// Gets or sets the maximum buffer size for data read by the application
  /// before backpressure is applied.
  int transportBufferSize;

  /// Gets or sets the maximum buffer size for data written by the application
  /// before backpressure is applied.
  int applicationMaxBufferSize;

  /// Gets or sets the URL used to send HTTP requests.
  Uri? url;

  /// Gets or sets a bitmask combining one or more [HttpTransportType] values
  /// that specify what transports the client should use to send HTTP requests.
  int? transports;

  /// Gets or sets a value indicating whether negotiation is skipped when
  /// connecting to the server.
  bool skipNegotiation;

  /// Gets or sets an access token provider that will be called to return a
  /// token for each HTTP request.
  AccessTokenProvider? accessTokenProvider;

  /// Gets or sets a close timeout.
  Duration closeTimeout;

  /// Gets or sets the default [TransferFormat] to use if [HttpConnection.start]
  /// is called instead of [HttpConnection.start].
  TransferFormat defaultTransferFormat;
}
