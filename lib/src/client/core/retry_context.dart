import 'retry_policy.dart';

/// The context passed to [RetryPolicy.nextRetryDelay] to help the
/// policy determine how long to wait before the next retry and
/// whether there should be another retry at all.
class RetryContext {
  RetryContext({
    required this.previousRetryCount,
    required this.elapsedTime,
    this.retryReason,
  });

  /// The number of consecutive failed retries so far.
  int previousRetryCount;

  /// The amount of time spent retrying so far.
  DateTime elapsedTime;

  /// The error precipitating the current retry if any.
  Exception? retryReason;
}
