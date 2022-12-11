// This record separator is supposed to be used only for JSON payloads
// where 0x1e character will not occur (is not a valid character) and
// therefore it is safe to not escape it
import 'dart:typed_data';

const recordSeparator = 0x1e;

void writeRecordSeparator(BytesBuilder output) =>
    output.addByte(recordSeparator);
