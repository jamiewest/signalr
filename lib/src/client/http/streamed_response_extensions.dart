import 'package:http/http.dart';

extension StreamedResponseExtensions on StreamedResponse {
  void ensureSuccessStatusCode() {
    if (statusCode < 200 || statusCode > 299) {
      throw Exception('The HTTP response is unsuccessful.');
    }
  }
}
