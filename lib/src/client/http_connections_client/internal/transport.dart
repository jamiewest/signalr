import 'dart:async';

import 'package:extensions/primitives.dart';

import '../../../common/shared/duplex_pipe.dart';
import '../../../common/signalr_common/protocol/transfer_format.dart';

abstract class Transport implements DuplexPipe {
  Future<void> start({
    required Uri url,
    required TransferFormat transferFormat,
    CancellationToken? cancellationToken,
  });

  Future<void> stop();
}
