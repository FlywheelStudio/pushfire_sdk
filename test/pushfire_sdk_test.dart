import 'package:flutter_test/flutter_test.dart';
import 'package:pushfire_sdk/pushfire_sdk.dart';

void main() {
  test('SDK initializes correctly', () {
    PushfireSDK.initialize(apiKey: "test_key");
  });

  test('Tracking event does not throw', () async {
    await PushfireSDK.trackEvent("push_opened", "user_123");
  });
}
