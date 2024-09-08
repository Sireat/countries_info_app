// core/error/exceptions.dart

/// Exception thrown when a server-related error occurs.
class ServerException implements Exception {
  // Error message that describes the server exception.
  final String message;

  /// Constructor for ServerException with an optional message.
  /// Defaults to 'Server error occurred' if no message is provided.
  ServerException({this.message = 'Server error occurred'});

  /// Converts the exception to a readable string format.
  @override
  String toString() => 'ServerException: $message';
}

/// Exception thrown when a cache-related error occurs.
class CacheException implements Exception {
  // Error message that describes the cache exception.
  final String message;

  /// Constructor for CacheException with an optional message.
  /// Defaults to 'Cache error occurred' if no message is provided.
  CacheException({this.message = 'Cache error occurred'});

  /// Converts the exception to a readable string format.
  @override
  String toString() => 'CacheException: $message';
}
