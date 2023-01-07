import 'package:chunked_stream/chunked_stream.dart';
import 'package:extensions/logging.dart';
import 'package:http/http.dart';
import 'package:signalr/src/client/http_connections_client/internal/http_client_handler.dart';
import 'package:stream_channel/stream_channel.dart';

Future<void> sendMessages(
  Uri sendUrl,
  StreamChannel<List<int>> application,
  BaseClient httpClient,
  Logger logger,
  CancellationToken? cancellationToken,
) async {
  logger.sendStarted();

  try {
    while (true) {
      var result = await readByteStream(application.stream);
      var buffer = result.buffer;

      try {
        if (buffer.lengthInBytes > 0) {
          logger.sendingMessages(buffer.lengthInBytes, sendUrl);

          var request = HttpRequestMessage('POST', sendUrl, null);
          request.bodyBytes = buffer.asUint8List();
        }
      } on Exception catch (ex) {}
    }
  } on Exception catch (ex) {
    logger.errorSending(sendUrl, ex);
    rethrow;
  } finally {}

  logger.sendStopped();
}

extension SendUtilsLoggerExtensions on Logger {
  void sendStarted() {
    logDebug(
      'Starting the send loop.',
      eventId: EventId(100, 'SendStarted'),
    );
  }

  void sendCanceled() {
    logDebug(
      'Send loop canceled.',
      eventId: EventId(102, 'SendCanceled'),
    );
  }

  void sendStopped() {
    logDebug(
      'Send loop stopped.',
      eventId: EventId(101, 'SendStopped'),
    );
  }

  void sendingMessages(
    int count,
    Uri url,
  ) {
    logDebug(
      'Sending $count bytes to the server using url: ${url.toString()}.',
      eventId: EventId(103, 'SendingMessages'),
    );
  }

  void sentSuccessfully() {
    logDebug(
      'Message(s) sent successfully.',
      eventId: EventId(104, 'SentSuccessfully'),
    );
  }

  void noMessages() {
    logDebug(
      'No messages in batch to send.',
      eventId: EventId(105, 'NoMessages'),
    );
  }

  void errorSending(Uri url, Exception exception) {
    logError(
      'Error while sending to \'$url\'.',
      eventId: EventId(106, 'ErrorSending'),
      exception: exception,
    );
  }
}
