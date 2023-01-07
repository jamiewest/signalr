import 'hub_message.dart';

/// A base class for hub messages related to a specific invocation.
abstract class HubInvocationMessage extends HubMessage {
  final String? _invocationId;

  /// Initializes a new instance of the [HubInvocationMessage] class.
  HubInvocationMessage({
    required String? invocationId,
    required super.type,
    this.headers,
  }) : _invocationId = invocationId;

  /// Gets or sets a name/value collection of headers.
  final Map<String, String>? headers;

  /// Gets the invocation ID.
  String? get invocationId => _invocationId;
}
