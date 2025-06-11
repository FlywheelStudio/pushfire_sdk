import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'api/pushfire_api_client.dart';
import 'config/pushfire_config.dart';
import 'exceptions/pushfire_exceptions.dart';
import 'models/device.dart';
import 'models/subscriber.dart';
import 'models/subscriber_tag.dart';
import 'services/device_service.dart';
import 'services/subscriber_service.dart';
import 'services/tag_service.dart';
import 'utils/logger.dart';

/// Main implementation of the PushFire SDK
class PushFireSDKImpl {
  static PushFireSDKImpl? _instance;
  static bool _isInitialized = false;

  late final PushFireConfig _config;
  late final PushFireApiClient _apiClient;
  late final DeviceService _deviceService;
  late final SubscriberService _subscriberService;
  late final TagService _tagService;

  Device? _currentDevice;
  Subscriber? _currentSubscriber;

  // Stream controllers for events
  final _deviceRegisteredController = StreamController<Device>.broadcast();
  final _subscriberLoggedInController =
      StreamController<Subscriber>.broadcast();
  final _subscriberLoggedOutController = StreamController<void>.broadcast();
  final _fcmTokenRefreshController = StreamController<String>.broadcast();

  PushFireSDKImpl._();

  /// Get the singleton instance
  static PushFireSDKImpl get instance {
    if (!_isInitialized) {
      throw const PushFireNotInitializedException();
    }
    return _instance!;
  }

  /// Initialize the SDK
  static Future<void> initialize(PushFireConfig config) async {
    if (_isInitialized) {
      PushFireLogger.warning('PushFire SDK already initialized');
      return;
    }

    try {
      PushFireLogger.initialize(enableLogging: config.enableLogging);
      PushFireLogger.info('Initializing PushFire SDK');

      _instance = PushFireSDKImpl._();
      await _instance!._initialize(config);

      _isInitialized = true;
      PushFireLogger.info('PushFire SDK initialized successfully');
    } catch (e) {
      PushFireLogger.error('Failed to initialize PushFire SDK', e);
      _instance = null;
      rethrow;
    }
  }

  /// Internal initialization
  Future<void> _initialize(PushFireConfig config) async {
    _config = config;

    // Validate configuration
    if (config.apiKey.isEmpty) {
      throw const PushFireConfigurationException('API key is required');
    }

    if (config.baseUrl.isEmpty) {
      throw const PushFireConfigurationException('Base URL is required');
    }

    // Initialize Firebase if not already initialized
    try {
      await Firebase.initializeApp();
      PushFireLogger.info('Firebase initialized successfully');
    } catch (e) {
      // Firebase might already be initialized, which is fine
      PushFireLogger.info(
          'Firebase already initialized or initialization failed: $e');
    }

    // Initialize services
    _apiClient = PushFireApiClient(config);
    _deviceService = DeviceService(_apiClient);
    _subscriberService = SubscriberService(_apiClient, _deviceService);
    _tagService = TagService(_apiClient, _subscriberService);

    // Auto-register device
    await _autoRegisterDevice();

    // Set up FCM token refresh listener
    _setupFcmTokenRefreshListener();

    PushFireLogger.info('SDK services initialized');
  }

  /// Auto-register device on initialization
  Future<void> _autoRegisterDevice() async {
    try {
      PushFireLogger.info('Auto-registering device');
      _currentDevice = await _deviceService.registerDevice();
      _deviceRegisteredController.add(_currentDevice!);
      PushFireLogger.info('Device auto-registration completed');
    } catch (e) {
      PushFireLogger.error('Device auto-registration failed', e);
      // Don't throw here - allow SDK to continue working
    }
  }

  /// Set up FCM token refresh listener
  void _setupFcmTokenRefreshListener() {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      try {
        PushFireLogger.info('FCM token refreshed');
        PushFireLogger.logFcmToken(newToken);

        // Re-register device with new token
        _currentDevice = await _deviceService.registerDevice();
        _fcmTokenRefreshController.add(newToken);

        PushFireLogger.info('Device updated with new FCM token');
      } catch (e) {
        PushFireLogger.error('Failed to update device with new FCM token', e);
      }
    });
  }

  /// Login subscriber
  Future<Subscriber> loginSubscriber({
    required String externalId,
    String? name,
    String? email,
    String? phone,
  }) async {
    _ensureInitialized();

    try {
      _currentSubscriber = await _subscriberService.loginSubscriber(
        externalId: externalId,
        name: name,
        email: email,
        phone: phone,
      );

      _subscriberLoggedInController.add(_currentSubscriber!);
      return _currentSubscriber!;
    } catch (e) {
      PushFireLogger.error('Subscriber login failed', e);
      rethrow;
    }
  }

  /// Update subscriber
  Future<Subscriber> updateSubscriber({
    String? name,
    String? email,
    String? phone,
  }) async {
    _ensureInitialized();

    final currentSubscriber = await _subscriberService.getCurrentSubscriber();
    if (currentSubscriber?.id == null) {
      throw const PushFireSubscriberException('No subscriber logged in');
    }

    try {
      // Always use current subscriber's externalId (backend doesn't allow updates)
      await _subscriberService.updateSubscriber(
        subscriberId: currentSubscriber!.id!,
        externalId: currentSubscriber.externalId,
        name: name,
        email: email,
        phone: phone,
      );

      // Update the local subscriber state (externalId remains unchanged)
      _currentSubscriber = currentSubscriber.copyWith(
        name: name,
        email: email,
        phone: phone,
      );

      // Store updated subscriber data
      await _subscriberService.storeSubscriberData(_currentSubscriber!);

      return _currentSubscriber!;
    } catch (e) {
      PushFireLogger.error('Subscriber update failed', e);
      rethrow;
    }
  }

  /// Logout subscriber
  Future<void> logoutSubscriber() async {
    _ensureInitialized();

    try {
      await _subscriberService.logoutSubscriber();
      _currentSubscriber = null;
      _subscriberLoggedOutController.add(null);
    } catch (e) {
      PushFireLogger.error('Subscriber logout failed', e);
      rethrow;
    }
  }

  /// Add tag to current subscriber
  Future<SubscriberTag> addTag(String tagId, String value) async {
    _ensureInitialized();
    return await _tagService.addTag(tagId, value);
  }

  /// Update tag for current subscriber
  Future<SubscriberTag> updateTag(String tagId, String value) async {
    _ensureInitialized();
    return await _tagService.updateTag(tagId, value);
  }

  /// Remove tag from current subscriber
  Future<void> removeTag(String tagId) async {
    _ensureInitialized();
    return await _tagService.removeTag(tagId);
  }

  /// Add multiple tags
  Future<List<SubscriberTag>> addTags(Map<String, String> tags) async {
    _ensureInitialized();
    return await _tagService.addTags(tags);
  }

  /// Update multiple tags
  Future<List<SubscriberTag>> updateTags(Map<String, String> tags) async {
    _ensureInitialized();
    return await _tagService.updateTags(tags);
  }

  /// Remove multiple tags
  Future<void> removeTags(List<String> tagIds) async {
    _ensureInitialized();
    return await _tagService.removeTags(tagIds);
  }

  /// Get current device
  Device? get currentDevice => _currentDevice;

  /// Get current subscriber
  Future<Subscriber?> getCurrentSubscriber() async {
    _ensureInitialized();
    _currentSubscriber ??= await _subscriberService.getCurrentSubscriber();
    return _currentSubscriber;
  }

  /// Check if subscriber is logged in
  Future<bool> isSubscriberLoggedIn() async {
    _ensureInitialized();
    return await _subscriberService.isSubscriberLoggedIn();
  }

  /// Get device ID
  Future<String?> getDeviceId() async {
    _ensureInitialized();
    return await _deviceService.getDeviceId();
  }

  /// Get subscriber ID
  Future<String?> getSubscriberId() async {
    _ensureInitialized();
    return await _subscriberService.getSubscriberId();
  }

  /// Get SDK configuration
  PushFireConfig get config {
    _ensureInitialized();
    return _config;
  }

  /// Check if SDK is initialized
  static bool get isInitialized => _isInitialized;

  // Event streams

  /// Stream of device registration events
  Stream<Device> get onDeviceRegistered => _deviceRegisteredController.stream;

  /// Stream of subscriber login events
  Stream<Subscriber> get onSubscriberLoggedIn =>
      _subscriberLoggedInController.stream;

  /// Stream of subscriber logout events
  Stream<void> get onSubscriberLoggedOut =>
      _subscriberLoggedOutController.stream;

  /// Stream of FCM token refresh events
  Stream<String> get onFcmTokenRefresh => _fcmTokenRefreshController.stream;

  /// Clear all data and reset SDK
  Future<void> reset() async {
    _ensureInitialized();

    try {
      PushFireLogger.info('Resetting SDK');

      // Logout subscriber if logged in
      if (await isSubscriberLoggedIn()) {
        await logoutSubscriber();
      }

      // Clear device data
      await _deviceService.clearDeviceData();

      // Reset current state
      _currentDevice = null;
      _currentSubscriber = null;

      PushFireLogger.info('SDK reset completed');
    } catch (e) {
      PushFireLogger.error('SDK reset failed', e);
      rethrow;
    }
  }

  /// Dispose SDK resources
  void dispose() {
    if (!_isInitialized) return;

    PushFireLogger.info('Disposing SDK');

    _apiClient.dispose();
    _deviceRegisteredController.close();
    _subscriberLoggedInController.close();
    _subscriberLoggedOutController.close();
    _fcmTokenRefreshController.close();

    _instance = null;
    _isInitialized = false;

    PushFireLogger.info('SDK disposed');
  }

  /// Ensure SDK is initialized
  void _ensureInitialized() {
    if (!_isInitialized) {
      throw const PushFireNotInitializedException();
    }
  }
}
