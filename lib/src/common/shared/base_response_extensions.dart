import 'package:http/http.dart';

extension BaseResponseExtensions on BaseResponse {
  /// The HTTP response message if the call is successful.
  BaseResponse ensureSuccessStatusCode() {
    if (!isSuccessStatusCode) {
      throw Exception(
        'Response status code does not indicate'
        ' success: $statusCode ($reasonPhrase)',
      );
    }
    return this;
  }

  bool get isSuccessStatusCode => statusCode >= 200 && statusCode <= 299;
}
