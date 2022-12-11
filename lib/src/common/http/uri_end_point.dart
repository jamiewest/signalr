import 'end_point.dart';

/// An [EndPoint] defined by a [Uri].
class UriEndPoint implements EndPoint {
  /// Initializes a new instance of the [UriEndPoint]class.
  UriEndPoint({required this.uri});

  /// The [Uri] defining the [EndPoint].
  final Uri uri;

  @override
  String toString() => uri.toString();
}
