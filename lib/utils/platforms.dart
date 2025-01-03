abstract final class Platforms {
  static const android = 'android';
  static const fuchsia = 'fuchsia';
  static const ios = 'ios';
  static const linux = 'linux';
  static const macos = 'macos';
  static const windows = 'windows';

  /// Formats platform names with proper capitalization.
  /// * Handles special cases for iOS and macOS.
  static String formatName(String name) => switch (name.toLowerCase()) {
        'ios' => 'iOS',
        'macos' => 'macOS',
        final rest => rest[0].toUpperCase() + rest.substring(1),
      };
}
