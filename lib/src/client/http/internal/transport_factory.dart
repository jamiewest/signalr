import 'transport.dart';

abstract class TransportFactory {
  Transport createTransport(int availableServerTransports);
}
