/// Metadata that describes the [Hub] information associated with
/// a specific endpoint.
class HubMetadata {
  /// Constructs the [HubMetadata] of the given [Hub] type.
  const HubMetadata(this.hubType);

  /// The type of [Hub].
  final Type hubType;
}
