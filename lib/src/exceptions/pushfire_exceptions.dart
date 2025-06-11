/// Base exception class for PushFire SDK
abstract class PushFireException implements Exception {
  /// Error message
  final String message;

  /// Optional error code
  final String? code;

  /// Optional underlying error
  final dynamic originalError;

  const PushFireException(this.message, {this.code, this.originalError});

  @override
  String toString() {
    if (code != null) {
      return 'PushFireException($code): $message';
    }
    return 'PushFireException: $message';
  }
}

/// Exception thrown when API requests fail
class PushFireApiException extends PushFireException {
  /// HTTP status code
  final int? statusCode;

  /// Response body
  final String? responseBody;

  const PushFireApiException(
    super.message, {
    super.code,
    super.originalError,
    this.statusCode,
    this.responseBody,
  });

  @override
  String toString() {
    final buffer = StringBuffer('PushFireApiException');
    if (code != null) buffer.write('($code)');
    if (statusCode != null) buffer.write(' [HTTP $statusCode]');
    buffer.write(': $message');
    return buffer.toString();
  }
}

/// Exception thrown when SDK is not initialized
class PushFireNotInitializedException extends PushFireException {
  const PushFireNotInitializedException()
      : super(
            'PushFire SDK is not initialized. Call PushFireSDK.initialize() first.');
}

/// Exception thrown when configuration is invalid
class PushFireConfigurationException extends PushFireException {
  const PushFireConfigurationException(super.message,
      {super.code, super.originalError});
}

/// Exception thrown when device registration fails
class PushFireDeviceException extends PushFireException {
  const PushFireDeviceException(super.message,
      {super.code, super.originalError});
}

/// Exception thrown when subscriber operations fail
class PushFireSubscriberException extends PushFireException {
  const PushFireSubscriberException(super.message,
      {super.code, super.originalError});
}

/// Exception thrown when tag operations fail
class PushFireTagException extends PushFireException {
  const PushFireTagException(super.message, {super.code, super.originalError});
}

/// Exception thrown when network operations fail
class PushFireNetworkException extends PushFireException {
  const PushFireNetworkException(super.message,
      {super.code, super.originalError});
}
