// import 'dart:async';

// import 'package:extensions/logging.dart';
// import 'package:http/http.dart';
// import 'package:stream_channel/stream_channel.dart';

// import '../../../common/signalr_common/protocol/transfer_format.dart';
// import '../http_connection_options.dart';

// import 'http_client_handler.dart';
// import 'transport.dart';

// class LongPollingTransport extends Transport {
//   final BaseClient _httpClient;
//   final Logger _logger;
//   final HttpConnectionOptions _httpConnectionOptions;
//   StreamChannel<List<int>>? _application;
//   StreamChannel<List<int>>? _transport;
//   Exception? _error;
//   final CancellationTokenSource _transportCts = CancellationTokenSource();
//   final Future<void> running = Future.value();

//   @override
//   Stream<List<int>> get stream => _transport!.stream;

//   @override
//   StreamSink<List<int>> get sink => _transport!.sink;

//   LongPollingTransport(
//     BaseClient httpClient,
//     HttpConnectionOptions? httpConnectionOptions,
//     LoggerFactory? loggerFactory,
//   )   : _httpClient = httpClient,
//         _logger = (loggerFactory ?? NullLoggerFactory.instance)
//             .createLogger('LongPollingTransport'),
//         _httpConnectionOptions =
//             httpConnectionOptions ?? HttpConnectionOptions();

//   @override
//   Future<void> start(
//       {required Uri uri,
//       required TransferFormat transferFormat,
//       required CancellationToken? cancellationToken}) {
//     if (transferFormat != TransferFormat.binary ||
//         transferFormat != TransferFormat.text) {
//       throw Exception(
//         'The \'$transferFormat\' transfer format is not supported by this transport.',
//       );
//     }

//     _logger.startTransport(transferFormat);
//   }

//   Future<void> _process(Uri url) {
//     assert(_application != null);

//     var receiving = _poll(url, _transportCts.token);
//   }

//   @override
//   Future<void> stop() async {
//     _logger.transportStopping();

//     if (_application == null) {
//       // We never started
//       return;
//     }

//     try {
//       await running;
//     } on Exception catch (ex) {
//       _logger.transportStopped(ex);
//       rethrow;
//     }

//     _transport!.sink.close();

//     _logger.transportStopped(null);
//   }

//   Future<void> _poll(
//     Uri pollUrl,
//     CancellationToken cancellationToken,
//   ) async {
//     assert(_application != null);

//     _logger.startReceive();

//     try {
//       while (!cancellationToken.isCancellationRequested) {
//         var request = HttpRequestMessage('GET', pollUrl, null);

//         Response response;
//         try {
//           var streamedResponse = await _httpClient.send(request);
//           response = await Response.fromStream(streamedResponse);
//         } on Exception catch (ex) {
//           rethrow;
//         }

//         _logger.pollResponseReceived(response);

//         // response.EnsureSuccessStatusCode(); TODO: Make extension method for this.

//         if (response.statusCode == 204 ||
//             cancellationToken.isCancellationRequested) {
//           _logger.closingConnection();
//           // Transport closed or polling stopped, we're done
//           break;
//         } else {
//           _logger.receivedMessages();
//           _application!.sink.add(response.bodyBytes);
//         }
//       }
//     } on Exception catch (ex) {
//       _logger.errorPolling(pollUrl, ex);
//       _error = ex;
//     } finally {
//       _application!.sink.close();

//       _logger.receiveStopped();
//     }

//     Future<void> _sendDeleteRequest(Uri url) async {
//       try {
//         _logger.sendingDeleteRequest(url);

//         var response = await _httpClient.delete(url);

//         if (response.statusCode == 404) {
//           _logger.connectionAlreadyClosedSendingDeleteRequest(url);
//         } else {
//           // Check for non-404 errors
//           // response.EnsureSuccessStatusCode();
//           _logger.deleteRequestAccepted(url);
//         }
//       } on Exception catch (ex) {
//         _logger.errorSendingDeleteRequest(url, ex);
//       }
//     }
//   }
// }

// extension SendUtilsLoggerExtensions on Logger {
//   void startTransport(TransferFormat transferFormat) {
//     logInformation(
//       'Starting transport. Transfer mode: $transferFormat.',
//       eventId: const EventId(1, 'StartTransport'),
//     );
//   }

//   void transportStopped(Exception? exception) {
//     logDebug(
//       'Transport stopped.',
//       eventId: const EventId(2, 'TransportStopped'),
//       exception: exception,
//     );
//   }

//   void startReceive() {
//     logDebug(
//       'Starting receive loop.',
//       eventId: const EventId(3, 'StartReceive'),
//     );
//   }

//   void transportStopping() {
//     logInformation(
//       'Transport is stopping.',
//       eventId: const EventId(6, 'TransportStopping'),
//     );
//   }

//   void receiveCanceled() {
//     logDebug(
//       'Receive loop canceled.',
//       eventId: const EventId(5, 'ReceiveCanceled'),
//     );
//   }

//   void receiveStopped() {
//     logDebug(
//       'Receive loop stopped.',
//       eventId: const EventId(4, 'ReceiveStopped'),
//     );
//   }

//   void closingConnection() {
//     logDebug(
//       'The server is closing the connection.',
//       eventId: const EventId(7, 'ClosingConnection'),
//     );
//   }

//   void receivedMessages() {
//     logDebug(
//       'Received messages from the server.',
//       eventId: const EventId(8, 'ReceivedMessages'),
//     );
//   }

//   void errorPolling(Uri pollUrl, Exception exception) {
//     logError(
//       'Error while polling \'$pollUrl\'.',
//       eventId: const EventId(9, 'ErrorPolling'),
//       exception: exception,
//     );
//   }

//   void pollResponseReceived(Response response) {
//     if (isEnabled(LogLevel.trace)) {
//       logTrace(
//         'Poll response with status code ${response.statusCode} received from server. Content length: ${response.contentLength}.',
//         eventId: const EventId(10, 'PollResponseReceived'),
//       );
//     }
//   }

//   void sendingDeleteRequest(Uri pollUrl) {
//     logDebug(
//       'Sending DELETE request to \'$pollUrl\'.',
//       eventId: const EventId(8, 'SendingDeleteRequest'),
//     );
//   }

//   void deleteRequestAccepted(Uri pollUrl) {
//     logDebug(
//       'DELETE request to \'$pollUrl\' accepted.',
//       eventId: const EventId(12, 'DeleteRequestAccepted'),
//     );
//   }

//   void errorSendingDeleteRequest(Uri pollUrl, Exception ex) {
//     logError(
//       'Error sending DELETE request to \'$pollUrl\'.',
//       eventId: const EventId(13, 'ErrorSendingDeleteRequest'),
//       exception: ex,
//     );
//   }

//   void connectionAlreadyClosedSendingDeleteRequest(Uri pollUrl) {
//     logDebug(
//       'A 404 response was returned from sending DELETE request to \'$pollUrl\', likely because the transport was already closed on the server.',
//       eventId: const EventId(14, 'ConnectionAlreadyClosedSendingDeleteRequest'),
//     );
//   }
// }
