class DuplexPipe {}

class DuplexPipePair {
  final DuplexPipe _transport;
  final DuplexPipe _application;

  DuplexPipePair(
    DuplexPipe transport,
    DuplexPipe application,
  )   : _transport = transport,
        _application = application;

  DuplexPipe get transport => _transport;

  DuplexPipe get application => _application;
}
