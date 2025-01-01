/// Common Flutter Platform Exception Codes.
abstract final class ErrorCodes {
  // Platform/Plugin Related
  /// Platform not supported.
  static const unsupportedPlatform = 'UNSUPPORTED_PLATFORM';

  /// Feature not implemented.
  static const notImplemented = 'NOT_IMPLEMENTED';

  /// Service/feature unavailable.
  static const unavailable = 'UNAVAILABLE';

  // Method Channel Related
  /// Generic failure.
  static const failed = 'FAILED';

  /// Invalid parameter.
  static const invalidArgument = 'INVALID_ARGUMENT';

  /// Method doesn't exist.
  static const methodNotFound = 'METHOD_NOT_FOUND';

  /// Channel communication error.
  static const channelError = 'CHANNEL_ERROR';

  // Permission Related
  /// Access denied.
  static const permissionDenied = 'PERMISSION_DENIED';

  /// Feature restricted.
  static const restricted = 'RESTRICTED';

  /// Not authorized.
  static const notAuthorized = 'NOT_AUTHORIZED';

  // Resource Related
  /// Resource not found.
  static const notFound = 'NOT_FOUND';

  /// Resource exists.
  static const alreadyExists = 'ALREADY_EXISTS';

  /// Resource limit reached.
  static const resourceExhausted = 'RESOURCE_EXHAUSTED';

  // State Related
  /// Invalid operation state.
  static const invalidState = 'INVALID_STATE';

  /// Operation timed out.
  static const timeout = 'TIMEOUT';

  /// Operation cancelled
  static const cancelled = 'CANCELLED';

  // Authentication Related
  /// Not authenticated.
  static const unauthenticated = 'UNAUTHENTICATED';

  /// Not authorized.
  static const unauthorized = 'UNAUTHORIZED';

  /// Auth token expired.
  static const tokenExpired = 'TOKEN_EXPIRED';
}
