/// A boolean indicating whether the app is running in debug mode.
/// This checks the environment and returns true if not in production.
const debugMode = !bool.fromEnvironment('dart.vm.product');
