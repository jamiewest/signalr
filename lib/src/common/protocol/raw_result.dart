import 'dart:ffi';
import 'dart:typed_data';

/// Type returned to [HubProtocol] implementations to let them know
/// the object being deserialized should be stored as raw serialized
/// bytes in the format of the protocol being used.
///
/// In Json that would mean storing the byte representation of ascii
/// {"prop":10} as an example.
class RawResult {
  /// Stores the raw serialized bytes of a [CompletionMessage.result] for
  /// forwarding to another server. Will copy the passed in bytes to
  /// internal storage.
  RawResult({required this.rawSerializedData});

  /// The raw serialized bytes from the client.
  final UnmodifiableInt8ListView rawSerializedData;
}
