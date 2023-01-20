import 'package:extensions/logging.dart';

import '../../common/http_connections_common/http_transport_type.dart';
import '../../common/signalr_common/protocol/transfer_format.dart';

extension HttpConnectionLoggerExtensions on Logger {
  void starting() {
    logDebug(
      'Starting HttpConnection.',
      eventId: const EventId(1, 'Starting'),
    );
  }

  void skippingStart() {
    logDebug(
      'Skipping start, connection is already started.',
      eventId: const EventId(2, 'SkippingStart'),
    );
  }

  void started() {
    logInformation(
      'HttpConnection Started.',
      eventId: const EventId(3, 'Started'),
    );
  }

  void disposingHttpConnection() {
    logDebug(
      'Disposing HttpConnection.',
      eventId: const EventId(4, 'DisposingHttpConnection'),
    );
  }

  void skippingDispose() {
    logDebug(
      'Skipping dispose, connection is already disposed.',
      eventId: const EventId(5, 'SkippingDispose'),
    );
  }

  void disposed() {
    logInformation(
      'HttpConnection Disposed.',
      eventId: const EventId(6, 'Disposed'),
    );
  }

  void startingTransport(HttpTransportType transportType, Uri url) {
    if (isEnabled(LogLevel.debug)) {
      logDebug(
        'Starting transport \'${transportType.name}\' with Url: $url.',
        eventId: const EventId(7, 'StartingTransport'),
      );
    }
  }

  void establishingConnection(Uri url) {
    logDebug(
      'Establishing connection with server at \'$url\'.',
      eventId: const EventId(8, 'EstablishingConnection'),
    );
  }

  void connectionEstablished(String connectionId) {
    logDebug(
      'Established connection \'$connectionId\' with the server.',
      eventId: const EventId(9, 'Established'),
    );
  }

  void errorWithNegotiation(Uri url, Exception exception) {
    logError(
      'Failed to start connection. Error getting negotiation response'
      ' from \'$url\'.',
      eventId: const EventId(10, 'ErrorWithNegotiation'),
      exception: exception,
    );
  }

  void errorStartingTransport(
    HttpTransportType transportType,
    Exception exception,
  ) {
    logError(
      'Failed to start connection. Error starting transport'
      ' \'${transportType.name}\'.',
      eventId: const EventId(11, 'ErrorStartingTransport'),
      exception: exception,
    );
  }

  void transportNotSupported(String transportName) {
    logDebug(
      'Skipping transport $transportName because it is not supported by'
      ' this client.',
      eventId: const EventId(12, 'TransportNotSupported'),
    );
  }

  void transportDoesNotSupportTransferFormat(
    HttpTransportType transport,
    TransferFormat transferFormat,
  ) {
    if (isEnabled(LogLevel.debug)) {
      logDebug(
        'Skipping transport ${transport.name} because it does not support'
        ' the requested transfer format \'${transferFormat.toString()}\'.',
        eventId: const EventId(13, 'TransportDoesNotSupportTransferFormat'),
      );
    }
  }

  void transportDisabledByClient(HttpTransportType transport) {
    if (isEnabled(LogLevel.debug)) {
      logDebug(
        'Skipping transport ${transport.name} because it was disabled'
        ' by the client.',
        eventId: const EventId(14, 'TransportDisabledByClient'),
      );
    }
  }

  void transportFailed(
    HttpTransportType transport,
    Exception ex,
  ) {
    if (isEnabled(LogLevel.debug)) {
      logDebug(
        'Skipping transport ${transport.name} because it failed to initialize.',
        eventId: const EventId(15, 'TransportFailed'),
        exception: ex,
      );
    }
  }

  void webSocketsNotSupportedByOperatingSystem() {
    logDebug(
      'Skipping WebSockets because they are not supported by the'
      ' operating system.',
      eventId: const EventId(16, 'WebSocketsNotSupportedByOperatingSystem'),
    );
  }

  void transportThrewExceptionOnStop(Exception ex) {
    logError(
      'The transport threw an exception while stopping.',
      eventId: const EventId(17, 'TransportThrewExceptionOnStop'),
      exception: ex,
    );
  }

  void transportStarted(HttpTransportType transport) {
    logDebug(
      'Transport \'${transport.name}\' started.',
      eventId: const EventId(18, 'TransportStarted'),
    );
  }

  void serverSentEventsNotSupportedByBrowser() {
    logDebug(
      'Skipping ServerSentEvents because they are not supported by the'
      ' browser.',
      eventId: const EventId(19, 'ServerSentEventsNotSupportedByBrowser'),
    );
  }

  void cookiesNotSupported() {
    logTrace(
      'Cookies are not supported on this platform.',
      eventId: const EventId(20, 'CookiesNotSupported'),
    );
  }

  void retryAccessToken(int statusCode) {
    logDebug(
      '$statusCode received, getting a new access token and retrying request.',
      eventId: const EventId(21, 'RetryAccessToken'),
    );
  }
}
