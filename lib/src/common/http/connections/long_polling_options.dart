/// Options used to configure the long polling transport.
class LongPollingOptions {
  LongPollingOptions({
    this.pollTimeout = const Duration(seconds: 90),
  });

  /// Gets or sets the poll timeout.
  Duration pollTimeout;
}
