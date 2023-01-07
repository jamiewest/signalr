import 'package:uri/uri.dart';

Uri appendPath(Uri url, String path) {
  final builder = UriBuilder.fromUri(url);
  if (!builder.path.endsWith('/')) {
    builder.path += '/';
  }
  builder.path += path;
  return builder.build();
}
