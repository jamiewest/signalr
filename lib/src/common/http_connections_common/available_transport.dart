/// Part of the [NegotiationResponse] that represents an individual
/// transport and the trasfer formats the transport supports.
class AvailableTransport {
  AvailableTransport({
    required this.transport,
    required this.transferFormats,
  });

  /// A transport available on the server.
  final String? transport;

  /// A list of formats supported by the transport.
  /// Examples include 'Text' and 'Binary'.
  final List<String>? transferFormats;
}
