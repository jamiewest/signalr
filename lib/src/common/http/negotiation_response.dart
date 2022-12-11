import 'available_transport.dart';

/// A response to a '/negotiate' request.
class NegotiationResponse {
  NegotiationResponse({
    this.url,
    this.accessToken,
    this.connectionId,
    this.connectionToken,
    this.version = 0,
    this.availableTransports,
    this.error,
  });

  factory NegotiationResponse.fromJson(Map<String, dynamic> json) {
    return NegotiationResponse(
      connectionId: json['connectionId'] as String?,
      connectionToken: json['connectionToken'] as String?,
      version: json['negotiateVersion'] as int,
      availableTransports:
          _listFromJson(json['availableTransports'] as List<dynamic>?),
      url: json['url'] as String?,
      accessToken: json['accessToken'] as String?,
      error: json['error'] as String?,
    );
  }

  /// An optional Url to redirect the client to another endpoint.
  String? url;

  /// An optional access token to go along with the Url.
  String? accessToken;

  /// The public ID for the connection.
  String? connectionId;

  /// The private ID for the connection.
  String? connectionToken;

  /// The minimum value between the version the client sends and the maximum
  /// version the server supports.
  int version;

  /// A list of transports the server supports.
  List<AvailableTransport>? availableTransports;

  /// An optional error during the negotiate. If this is not null the other
  /// properties on the response can be ignored.
  String? error;
}

AvailableTransport _fromJson(Map<String, dynamic> json) {
  return AvailableTransport(
    transport: json['transport'] as String?,
    transferFormats:
        List<dynamic>.from(json['transferFormats'] as Iterable<dynamic>)
            .map((value) => value as String)
            .toList(),
  );
}

List<AvailableTransport>? _listFromJson(List<dynamic>? json) {
  return json == null
      ? <AvailableTransport>[]
      : json.map((value) => _fromJson(value as Map<String, dynamic>)).toList();
}
