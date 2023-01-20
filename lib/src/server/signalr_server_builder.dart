import 'package:extensions/dependency_injection.dart';

import '../common/signalr_common/signalr_builder.dart';

/// A builder abstraction for configuring SignalR servers.
class SignalRServerBuilder implements SignalRBuilder {
  final ServiceCollection _services;

  SignalRServerBuilder(ServiceCollection services) : _services = services;

  @override
  ServiceCollection get services => _services;
}
