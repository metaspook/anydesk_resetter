import 'dart:io';

extension PlatformExt on Platform {
  static String? _cachedVersion;

  static String get osVersion {
    return _cachedVersion ??= _parseVersion(Platform.operatingSystemVersion);
  }

  static String _parseVersion(String fullVersion) {
    if (Platform.isWindows) {
      final match =
          RegExp(r'Windows (\d+).*\(Build (\d+)\)').firstMatch(fullVersion);
      return match != null
          ? 'Windows ${match.group(1)} (${match.group(2)})'
          : fullVersion;
    }

    if (Platform.isMacOS) {
      final match = RegExp(r'macOS (\d+\.\d+\.\d+)').firstMatch(fullVersion);
      return match != null ? 'macOS ${match.group(1)}' : fullVersion;
    }

    if (Platform.isLinux) {
      return fullVersion.split(' ').take(2).join(' ');
    }

    return fullVersion;
  }
}
