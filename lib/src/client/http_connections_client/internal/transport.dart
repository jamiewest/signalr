import 'dart:async';

import 'package:extensions/primitives.dart';
import 'package:stream_channel/stream_channel.dart';

import '../../../common/signalr_common/protocol/transfer_format.dart';

abstract class Transport
    with StreamChannelMixin<List<int>>
    implements StreamChannel<List<int>> {
  Future<void> start({
    required Uri url,
    required TransferFormat transferFormat,
    required CancellationToken? cancellationToken,
  });

  Future<void> stop();
}
