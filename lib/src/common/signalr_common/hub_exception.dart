/// The exception thrown from a hub when an error occurs.
///
/// Exceptions often contain sensitive information, such as connection
/// information. Because of this, SignalR does not expose the details of
/// exceptions that occur on the server to the client. However, instances
/// of [HubException] <b>are</b> sent to the client.
class HubException implements Exception {
  final String? _message;

  HubException([this._message]);

  @override
  String toString() {
    if (_message == null) return 'Exception';
    return 'Exception: $_message';
  }
}
