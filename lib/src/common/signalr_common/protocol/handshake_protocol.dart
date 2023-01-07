import 'dart:async';
import 'dart:convert';

import 'handshake_request_message.dart';
import 'handshake_response_message.dart';

/// Gets the bytes of a successful handshake message.
List<int> getSuccessfulHandshake() {
  final response = writeResponseMessage(HandshakeResponseMessage.empty);
  return response;
}

/// Writes the serialized representation of a [HandshakeRequestMessage]
/// to the specified [StreamSink].
List<int> writeRequestMessage(
  HandshakeRequestMessage requestMessage,
) {
  final json = requestMessage.toJson();
  final text = jsonEncode(json);

  final result = utf8.encode(text);

  return result;
}

/// Writes the serialized representation of a [HandshakeResponseMessage]
/// to the specified writer.
List<int> writeResponseMessage(HandshakeResponseMessage responseMessage) {
  final json = responseMessage.toJson();
  final jsonEncoded = jsonEncode(json);

  final result = utf8.encode(jsonEncoded);

  return result;
}

/// Creates a new [HandshakeResponseMessage] from the specified
/// serialized representation.
HandshakeResponseMessage parseResponseMessage(List<int> buffer) {
  final utf8Decoded = utf8.decode(buffer);
  final jsonDecoded = jsonDecode(utf8Decoded) as Map<String, dynamic>;

  final response = HandshakeResponseMessageExtensions.fromJson(jsonDecoded);

  return response;
}

/// Creates a new [HandshakeRequestMessage] from the specified
/// serialized representation.
HandshakeRequestMessage parseRequestMessage(List<int> buffer) {
  final utf8Decoded = utf8.decode(buffer);
  final jsonDecoded = jsonDecode(utf8Decoded) as Map<String, dynamic>;

  final response = HandshakeRequestMessageExtensions.fromJson(jsonDecoded);

  return response;
}
