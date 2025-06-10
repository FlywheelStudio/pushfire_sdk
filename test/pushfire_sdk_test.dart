import 'package:flutter_test/flutter_test.dart';
import 'package:pushfire_sdk/pushfire_sdk.dart';

void main() {
  group('PushFireSDK Tests', () {
    test('PushFireConfig creates correctly', () {
      const config = PushFireConfig(
        apiKey: 'test_api_key',
        baseUrl: 'https://test.pushfire.com',
      );
      
      expect(config.apiKey, 'test_api_key');
      expect(config.baseUrl, 'https://test.pushfire.com');
      expect(config.enableLogging, false);
      expect(config.timeoutSeconds, 30);
    });

    test('Device model creates correctly', () {
      const device = Device(
        id: 'test_id',
        fcmToken: 'test_token',
        os: 'iOS',
        osVersion: '15.0',
        language: 'en',
        manufacturer: 'Apple',
        model: 'iPhone',
        appVersion: '1.0.0',
        pushNotificationEnabled: true,
      );
      
      expect(device.id, 'test_id');
      expect(device.fcmToken, 'test_token');
      expect(device.os, 'iOS');
    });

    test('Subscriber model creates correctly', () {
      const subscriber = Subscriber(
        id: 'sub_id',
        deviceId: 'device_id',
        externalId: 'ext_id',
        name: 'Test User',
        email: 'test@example.com',
        phone: '+1234567890',
      );
      
      expect(subscriber.id, 'sub_id');
      expect(subscriber.name, 'Test User');
      expect(subscriber.email, 'test@example.com');
    });
  });
}
