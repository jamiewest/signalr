import 'package:extensions/configuration.dart';
import 'package:stream_channel/stream_channel.dart';

import '../../../common/protocol/transfer_format.dart';

abstract class Transport extends StreamChannelMixin {
  Future<void> start({
    required Uri uri,
    required TransferFormat transferFormat,
    required CancellationToken? cancellationToken,
  });

  Future<void> stop();
}
