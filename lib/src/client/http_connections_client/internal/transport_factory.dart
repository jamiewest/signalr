import '../../../common/http_connections_common/http_transport_type.dart';

import 'transport.dart';

abstract class TransportFactory {
  Transport createTransport(List<HttpTransportType> availableServerTransports);
}
