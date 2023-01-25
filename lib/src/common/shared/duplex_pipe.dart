import 'dart:async';

import 'package:stream_channel/stream_channel.dart';

class DuplexPipe {
  const DuplexPipe(
    this.input,
    this.output,
  );

  factory DuplexPipe.fromChannel(
    StreamChannel<List<int>> channel,
  ) =>
      DuplexPipe(
        channel.stream,
        channel.sink,
      );

  ///Gets the [Stream] half of the duplex pipe.
  final Stream<List<int>> input;

  /// Gets the [StreamSink] half of the duplex pipe.
  final StreamSink<List<int>> output;

  static DuplexPipePair createConnectionPair() {
    final controller = StreamChannelController<List<int>>();

    return DuplexPipePair(
      DuplexPipe.fromChannel(controller.local),
      DuplexPipe.fromChannel(controller.foreign),
    );
  }
}

class DuplexPipePair {
  const DuplexPipePair(
    this.transport,
    this.application,
  );

  final DuplexPipe transport;

  final DuplexPipe application;
}
