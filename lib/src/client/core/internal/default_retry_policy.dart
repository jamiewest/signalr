import '../retry_context.dart';
import '../retry_policy.dart';

class DefaultRetryPolicy implements RetryPolicy {
  final List<Duration?> _retryDelays;

  static List<Duration?> defaultRetryDelaysInMilliseconds = [
    Duration.zero,
    const Duration(seconds: 2),
    const Duration(seconds: 10),
    const Duration(seconds: 30),
    null,
  ];

  DefaultRetryPolicy([List<Duration?>? retryDelays])
      : _retryDelays = retryDelays ?? defaultRetryDelaysInMilliseconds;

  @override
  Duration? nextRetryDelay(RetryContext retryContext) =>
      _retryDelays[retryContext.previousRetryCount];
}
