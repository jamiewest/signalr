/// Represents the possible transfer formats.
enum TransferFormat {
  /// A binary transport format.
  binary('Binary'),

  /// A text transport format.
  text('Text'),
  ;

  const TransferFormat(this.name);

  final String name;

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
