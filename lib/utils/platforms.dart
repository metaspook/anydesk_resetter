/// Provides platform constants and utilities.
///
/// Example:
/// ```dart
/// print(Platforms.android); // android
/// {@template format_name}
/// print(Platforms.formatName(Platforms.windows)); // Windows
/// print(Platforms.formatName(Platforms.ios)); // iOS
/// {@endtemplate}
/// ```
abstract final class Platforms {
  /// Android platform identifier
  static const android = 'android';

  /// Fuchsia platform identifier
  static const fuchsia = 'fuchsia';

  /// iOS platform identifier
  static const ios = 'ios';

  /// Linux platform identifier
  static const linux = 'linux';

  /// macOS platform identifier
  static const macos = 'macos';

  /// Windows platform identifier
  static const windows = 'windows';

  /// Formats platform names with proper capitalization.
  /// * Handles special cases for iOS and macOS.
  /// ```dart
  /// {@macro format_name}
  /// ```
  static String formatName(String name) => switch (name.toLowerCase()) {
        ios => 'iOS',
        macos => 'macOS',
        final rest => rest[0].toUpperCase() + rest.substring(1),
      };
}
