import 'retry_context.dart';

/// An abstraction that controls when the client attempts to reconnect
/// and how many times it does so.
abstract class RetryPolicy {
  /// If passed to [HubConnectionBuilderExtensions.withAutomaticReconnect],
  /// this will be called after the transport loses a connection to determine
  /// if and for how long to wait before the next reconnect attempt.
  Duration? nextRetryDelay(RetryContext retryContext);
}
