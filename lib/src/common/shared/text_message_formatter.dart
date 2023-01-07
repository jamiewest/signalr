// This record separator is supposed to be used only for JSON payloads
// where 0x1e character will not occur (is not a valid character) and
// therefore it is safe to not escape it
import 'dart:typed_data';

const int recordSeparator = 0x1e;

void writeRecordSeparator(BytesBuilder output) =>
    output.addByte(recordSeparator);

mixin TextMessageFormat {
  static const RecordSeparatorCode = 0x1e;

  static String recordSeparator =
      String.fromCharCode(TextMessageFormat.RecordSeparatorCode);

  static String write(String output) {
    return '$output${TextMessageFormat.recordSeparator}';
  }

  static List<String> parse(String input) {
    if (input.isEmpty) {
      throw Exception('Message is incomplete.');
    }

    if (input[input.length - 1] != TextMessageFormat.recordSeparator) {
      throw Exception('Message is incomplete.');
    }

    var messages = input.split(TextMessageFormat.recordSeparator)..removeLast();
    return messages;
  }
}
