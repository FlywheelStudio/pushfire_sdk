/// Represents a tag associated with a subscriber
class SubscriberTag {
  /// Unique tag identifier
  final String tagId;
  
  /// Subscriber identifier
  final String subscriberId;
  
  /// Tag value
  final String value;
  
  const SubscriberTag({
    required this.tagId,
    required this.subscriberId,
    required this.value,
  });
  
  /// Create a SubscriberTag from JSON
  factory SubscriberTag.fromJson(Map<String, dynamic> json) {
    return SubscriberTag(
      tagId: json['tagId'] as String,
      subscriberId: json['subscriberId'] as String,
      value: json['value'] as String,
    );
  }
  
  /// Convert SubscriberTag to JSON
  Map<String, dynamic> toJson() {
    return {
      'tagId': tagId,
      'subscriberId': subscriberId,
      'value': value,
    };
  }
  
  /// Create a copy of this tag with updated values
  SubscriberTag copyWith({
    String? tagId,
    String? subscriberId,
    String? value,
  }) {
    return SubscriberTag(
      tagId: tagId ?? this.tagId,
      subscriberId: subscriberId ?? this.subscriberId,
      value: value ?? this.value,
    );
  }
  
  @override
  String toString() {
    return 'SubscriberTag(tagId: $tagId, subscriberId: $subscriberId, value: $value)';
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SubscriberTag &&
        other.tagId == tagId &&
        other.subscriberId == subscriberId &&
        other.value == value;
  }
  
  @override
  int get hashCode {
    return Object.hash(tagId, subscriberId, value);
  }
}