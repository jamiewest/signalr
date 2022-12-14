import 'http_transport_type.dart';

extension HttpTransportTypes on Iterable<HttpTransportType> {
  bool get hasWebSockets => contains(HttpTransportType.webSockets);
  bool get hasServerSentEvents => contains(HttpTransportType.serverSentEvents);
  bool get hasLongPolling => contains(HttpTransportType.longPolling);
  bool get hasNone => length == 0;

  static Iterable<HttpTransportType> get all => const <HttpTransportType>[
        HttpTransportType.longPolling,
        HttpTransportType.serverSentEvents,
        HttpTransportType.webSockets
      ];
}











// import 'dart:collection';

// import 'http_transport_type.dart';

// Iterable<int> get all => 





// bool hasTransport(int value, HttpTransportType httpTransportType) =>
//     value & httpTransportType.value != 0;

// List<HttpTransportType> getTransports(int value) {
//   List<HttpTransportType> httpTransportTypes = <HttpTransportType>[];
//   if (value == 0) {
//     httpTransportTypes.add(HttpTransportType.none);
//     return httpTransportTypes;
//   }

//   if (hasTransport(value, HttpTransportType.webSockets)) {
//     httpTransportTypes.add(HttpTransportType.webSockets);
//   }

//   if (hasTransport(value, HttpTransportType.serverSentEvents)) {
//     httpTransportTypes.add(HttpTransportType.serverSentEvents);
//   }

//   if (hasTransport(value, HttpTransportType.longPolling)) {
//     httpTransportTypes.add(HttpTransportType.longPolling);
//   }

//   return httpTransportTypes;
// }
