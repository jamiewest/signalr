import 'dart:async';

import 'package:extensions/logging.dart';
import 'package:http/http.dart';
import 'package:stream_channel/stream_channel.dart';

import '../../../common/shared/base_response_extensions.dart';
import 'http_client_handler.dart';

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
      var result = await ByteStream(application.stream).toBytes();

      var buffer = result.buffer;

      try {
        if (buffer.lengthInBytes > 0) {
          logger.sendingMessages(buffer.lengthInBytes, sendUrl);

          var request = HttpRequestMessage('POST', sendUrl, null)
            ..bodyBytes = buffer.asUint8List();

          var streamedResponse = await httpClient.send(request);
          var response = await Response.fromStream(streamedResponse);

          response.ensureSuccessStatusCode();

          logger.sentSuccessfully();

          await application.sink.done;
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
      eventId: const EventId(100, 'SendStarted'),
    );
  }

  void sendCanceled() {
    logDebug(
      'Send loop canceled.',
      eventId: const EventId(102, 'SendCanceled'),
    );
  }

  void sendStopped() {
    logDebug(
      'Send loop stopped.',
      eventId: const EventId(101, 'SendStopped'),
    );
  }

  void sendingMessages(
    int count,
    Uri url,
  ) {
    logDebug(
      'Sending $count bytes to the server using url: ${url.toString()}.',
      eventId: const EventId(103, 'SendingMessages'),
    );
  }

  void sentSuccessfully() {
    logDebug(
      'Message(s) sent successfully.',
      eventId: const EventId(104, 'SentSuccessfully'),
    );
  }

  void noMessages() {
    logDebug(
      'No messages in batch to send.',
      eventId: const EventId(105, 'NoMessages'),
    );
  }

  void errorSending(Uri url, Exception exception) {
    logError(
      'Error while sending to \'$url\'.',
      eventId: const EventId(106, 'ErrorSending'),
      exception: exception,
    );
  }
}
