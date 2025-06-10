/// Represents a device in the PushFire system
class Device {
  /// Unique device identifier
  final String? id;
  
  /// Firebase Cloud Messaging token
  final String fcmToken;
  
  /// Operating system (ios/android)
  final String os;
  
  /// Operating system version
  final String osVersion;
  
  /// Device language
  final String language;
  
  /// Device manufacturer
  final String manufacturer;
  
  /// Device model
  final String model;
  
  /// App version
  final String appVersion;
  
  /// Whether push notifications are enabled
  final bool pushNotificationEnabled;
  
  const Device({
    this.id,
    required this.fcmToken,
    required this.os,
    required this.osVersion,
    required this.language,
    required this.manufacturer,
    required this.model,
    required this.appVersion,
    required this.pushNotificationEnabled,
  });
  
  /// Create a Device from JSON
  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] as String?,
      fcmToken: json['fcmToken'] as String,
      os: json['os'] as String,
      osVersion: json['osVersion'] as String,
      language: json['language'] as String,
      manufacturer: json['manufacturer'] as String,
      model: json['model'] as String,
      appVersion: json['appVersion'] as String,
      pushNotificationEnabled: json['pushNotificationEnabled'] as bool,
    );
  }
  
  /// Convert Device to JSON
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'fcmToken': fcmToken,
      'os': os,
      'osVersion': osVersion,
      'language': language,
      'manufacturer': manufacturer,
      'model': model,
      'appVersion': appVersion,
      'pushNotificationEnabled': pushNotificationEnabled,
    };
    
    if (id != null) {
      json['id'] = id;
    }
    
    return json;
  }
  
  /// Create a copy of this device with updated values
  Device copyWith({
    String? id,
    String? fcmToken,
    String? os,
    String? osVersion,
    String? language,
    String? manufacturer,
    String? model,
    String? appVersion,
    bool? pushNotificationEnabled,
  }) {
    return Device(
      id: id ?? this.id,
      fcmToken: fcmToken ?? this.fcmToken,
      os: os ?? this.os,
      osVersion: osVersion ?? this.osVersion,
      language: language ?? this.language,
      manufacturer: manufacturer ?? this.manufacturer,
      model: model ?? this.model,
      appVersion: appVersion ?? this.appVersion,
      pushNotificationEnabled: pushNotificationEnabled ?? this.pushNotificationEnabled,
    );
  }
  
  @override
  String toString() {
    return 'Device(id: $id, os: $os, model: $model, pushNotificationEnabled: $pushNotificationEnabled)';
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Device &&
        other.id == id &&
        other.fcmToken == fcmToken &&
        other.os == os &&
        other.osVersion == osVersion &&
        other.language == language &&
        other.manufacturer == manufacturer &&
        other.model == model &&
        other.appVersion == appVersion &&
        other.pushNotificationEnabled == pushNotificationEnabled;
  }
  
  @override
  int get hashCode {
    return Object.hash(
      id,
      fcmToken,
      os,
      osVersion,
      language,
      manufacturer,
      model,
      appVersion,
      pushNotificationEnabled,
    );
  }
}