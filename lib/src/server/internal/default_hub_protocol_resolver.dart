import 'package:extensions/logging.dart';
import '../../common/signalr_common/protocol/hub_protocol.dart';
import '../hub_protocol_resolver.dart';

class DefaultHubProtocolResolver implements HubProtocolResolver {
  final Logger _logger;
  final List<HubProtocol> _hubProtocols;
  final Map<String, HubProtocol> _availableProtocols;

  DefaultHubProtocolResolver(
    List<HubProtocol> availableProtocols,
    Logger logger,
  )   : _logger = logger,
        _hubProtocols = availableProtocols,
        _availableProtocols = {for (var v in availableProtocols) v.name: v} {
    for (var protocol in availableProtocols) {
      _logger.registeredSignalRProtocol(
        protocol.name,
        protocol.runtimeType,
      );
    }
  }

  @override
  List<HubProtocol> get allProtocols => _hubProtocols;

  @override
  HubProtocol? getProtocol(
    String protocolName,
    List<String>? supportedProtocols,
  ) {
    if (_availableProtocols.containsKey(protocolName) &&
        (supportedProtocols == null ||
            supportedProtocols.contains(protocolName))) {
      final protocol = _availableProtocols[protocolName];
      _logger.foundImplementationForProtocol(protocolName);
      return protocol;
    }

    // null result indicates protocol is not supported
    // result will be validated by the caller
    return null;
  }
}

extension DefaultHubProtocolResolverLoggerExtensions on Logger {
  void registeredSignalRProtocol(
    String protocolName,
    Type implementationType,
  ) {
    logDebug(
      'Registered SignalR Protocol: $protocolName, implemented by'
      ' $implementationType.',
      eventId: const EventId(1, 'RegisteredSignalRProtocol'),
    );
  }

  void foundImplementationForProtocol(
    String protocolName,
  ) {
    logDebug(
      'Found protocol implementation for requested protocol: $protocolName.',
      eventId: const EventId(2, 'FoundImplementationForProtocol'),
    );
  }
}
