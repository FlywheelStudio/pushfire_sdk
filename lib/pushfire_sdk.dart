library pushfire_sdk;

import 'package:http/http.dart' as http;

class PushfireSDK {
  static String? _apiKey;

  /// Initialize the SDK
  static void initialize({required String apiKey}) {
    _apiKey = apiKey;
    print("PushfireSDK initialized with API key: $apiKey");
  }

  /// Track push notification events
  static Future<void> trackEvent(String eventType, String userId) async {
    if (_apiKey == null) {
      throw Exception("PushfireSDK is not initialized. Call initialize() first.");
    }

    final response = await http.post(
      Uri.parse("https://your-api.com/track"),
      body: {
        "apiKey": _apiKey,
        "event": eventType,
        "userId": userId,
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to track event");
    }
  }
}
