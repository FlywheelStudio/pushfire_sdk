/// Represents a subscriber in the PushFire system
class Subscriber {
  /// Unique subscriber identifier
  final String? id;
  
  /// Device ID associated with this subscriber
  final String? deviceId;
  
  /// External ID from your system
  final String externalId;
  
  /// Subscriber name
  final String? name;
  
  /// Subscriber email
  final String? email;
  
  /// Subscriber phone number
  final String? phone;
  
  const Subscriber({
    this.id,
    this.deviceId,
    required this.externalId,
    this.name,
    this.email,
    this.phone,
  });
  
  /// Create a Subscriber from JSON
  factory Subscriber.fromJson(Map<String, dynamic> json) {
    return Subscriber(
      id: json['id'] as String?,
      deviceId: json['deviceId'] as String?,
      externalId: json['externalId'] as String,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );
  }
  
  /// Convert Subscriber to JSON
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    
    if (id != null) json['id'] = id;
    if (deviceId != null) json['deviceId'] = deviceId;
    json['externalId'] = externalId;
    if (name != null) json['name'] = name;
    if (email != null) json['email'] = email;
    if (phone != null) json['phone'] = phone;
    
    return json;
  }
  
  /// Create a copy of this subscriber with updated values
  Subscriber copyWith({
    String? id,
    String? deviceId,
    String? externalId,
    String? name,
    String? email,
    String? phone,
  }) {
    return Subscriber(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      externalId: externalId ?? this.externalId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
  
  @override
  String toString() {
    return 'Subscriber(id: $id, externalId: $externalId, name: $name, email: $email)';
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Subscriber &&
        other.id == id &&
        other.deviceId == deviceId &&
        other.externalId == externalId &&
        other.name == name &&
        other.email == email &&
        other.phone == phone;
  }
  
  @override
  int get hashCode {
    return Object.hash(
      id,
      deviceId,
      externalId,
      name,
      email,
      phone,
    );
  }
}