/// Represents the possible transfer formats.
enum TransferFormat {
  /// A binary transport format.
  binary,

  /// A text transport format.
  text,
  ;

  static TransferFormat fromName(String? name) {
    switch (name) {
      case 'binary':
        return TransferFormat.binary;
      case 'text':
        return TransferFormat.text;
      default:
        return TransferFormat.text;
    }
  }
}
