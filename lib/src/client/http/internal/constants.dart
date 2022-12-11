import 'package:pub_semver/pub_semver.dart';
import "package:os_detect/os_detect.dart" as platform;
import 'package:quiver/strings.dart';

String userAgent = platform.isBrowser ? 'X-SignalR-User-Agent' : 'User-Agent';
String userAgentHeader = getUserAgentHeader();

String getUserAgentHeader() {
  final runtime = '.NET';
  final runtimeVersion = '';

  return constructUserAgent(
    Version.none,
    '',
    getOS(),
    runtime,
    runtimeVersion,
  );
}

String getOS() {
  if (platform.isWindows) {
    return 'Windows NT';
  } else if (platform.isMacOS) {
    return 'macOS';
  } else if (platform.isLinux) {
    return 'Linux';
  } else {
    return '';
  }
}

String constructUserAgent(
  Version version,
  String detailedVersion,
  String os,
  String runtime,
  String runtimeVersion,
) {
  var userAgent = 'Microsoft SignalR/${version.major}.${version.minor} (';

  if (!isBlank(detailedVersion)) {
    userAgent += detailedVersion;
  } else {
    userAgent += 'Unknown Version';
  }

  if (!isBlank(os)) {
    userAgent += '; $os';
  } else {
    userAgent += '; Unknown OS';
  }

  userAgent += '; $runtime';

  if (!isBlank(runtimeVersion)) {
    userAgent += '; $runtimeVersion';
  } else {
    userAgent += '; Unknown Runtime Version';
  }

  userAgent += ')';

  return userAgent;
}
