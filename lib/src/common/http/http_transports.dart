import 'http_transport_type.dart';

int get all =>
    HttpTransportType.webSockets.value |
    HttpTransportType.serverSentEvents.value |
    HttpTransportType.longPolling.value;

bool hasTransport(int value, HttpTransportType httpTransportType) =>
    value & httpTransportType.value != 0;

List<HttpTransportType> getTransports(int value) {
  List<HttpTransportType> httpTransportTypes = <HttpTransportType>[];
  if (value == 0) {
    httpTransportTypes.add(HttpTransportType.none);
    return httpTransportTypes;
  }

  if (hasTransport(value, HttpTransportType.webSockets)) {
    httpTransportTypes.add(HttpTransportType.webSockets);
  }

  if (hasTransport(value, HttpTransportType.serverSentEvents)) {
    httpTransportTypes.add(HttpTransportType.serverSentEvents);
  }

  if (hasTransport(value, HttpTransportType.longPolling)) {
    httpTransportTypes.add(HttpTransportType.longPolling);
  }

  return httpTransportTypes;
}
