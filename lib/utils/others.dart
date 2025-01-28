import 'dart:io';

//-- Constants
/// A boolean indicating whether the app is running in debug mode.
/// This checks the environment and returns true if not in production.
const debugMode = !bool.fromEnvironment('dart.vm.product');
const double appSpacing = 8;

//-- Extensions
extension StringIterableExt on Iterable<String> {
  String joinAsPath() => join(Platform.pathSeparator);
}
