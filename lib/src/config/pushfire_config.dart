/// Configuration class for PushFire SDK
class PushFireConfig {
  /// API key for authentication
  final String apiKey;
  
  /// Base URL for the PushFire API
  final String baseUrl;
  
  /// Enable debug logging
  final bool enableLogging;
  
  /// Timeout for HTTP requests in seconds
  final int timeoutSeconds;
  
  const PushFireConfig({
    required this.apiKey,
    this.baseUrl = 'https://jojnoebcqoqjlshwzmjm.supabase.co/functions/v1/',
    this.enableLogging = false,
    this.timeoutSeconds = 30,
  });
  
  /// Create a copy of this config with updated values
  PushFireConfig copyWith({
    String? apiKey,
    String? baseUrl,
    bool? enableLogging,
    int? timeoutSeconds,
  }) {
    return PushFireConfig(
      apiKey: apiKey ?? this.apiKey,
      baseUrl: baseUrl ?? this.baseUrl,
      enableLogging: enableLogging ?? this.enableLogging,
      timeoutSeconds: timeoutSeconds ?? this.timeoutSeconds,
    );
  }
  
  @override
  String toString() {
    return 'PushFireConfig(baseUrl: $baseUrl, enableLogging: $enableLogging, timeoutSeconds: $timeoutSeconds)';
  }
}