import 'dart:math';

import 'package:signalr/src/client/http_connections_client/http_connection.dart';
import 'package:signalr/src/client/http_connections_client/http_connection_options.dart';
import 'package:signalr/src/common/http_connections/http_transports.dart';
import 'package:signalr/src/common/signalr_common/protocol/transfer_format.dart';
import 'package:test/test.dart';

void main() {
  group('HttpConnectionTests', () {
    test('HttpConnectionOptionsDefaults', () {
      final httpOptions = HttpConnectionOptions();
      expect(httpOptions.transportMaxBufferSize, equals(1024 * 1024));
      expect(httpOptions.applicationMaxBufferSize, equals(1024 * 1024));
      expect(httpOptions.closeTimeout, equals(const Duration(seconds: 5)));
      expect(httpOptions.defaultTransferFormat, equals(TransferFormat.binary));
      expect(httpOptions.transports, equals(all));
    });
  });
}
