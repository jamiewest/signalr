import 'dart:async';
import 'dart:convert';

import 'negotiation_response.dart';

/// Writes the [response] to the [output].
void writeResponse(
  NegotiationResponse response,
  StreamSink<List<int>> output,
) {}

/// Parses a [NegotiationResponse] from the [content] as Json.
NegotiationResponse parseResponse(String content) {
  final result = json.decode(content) as Map<String, dynamic>;

  final negotiationResponse = NegotiationResponse.fromJson(result);

  return negotiationResponse;
}
