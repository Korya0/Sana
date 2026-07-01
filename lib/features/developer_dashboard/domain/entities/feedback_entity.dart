import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class FeedbackEntity {
  const FeedbackEntity({
    required this.id,
    required this.message,
    required this.timestamp,
    required this.metadata,
    this.contactInfo,
  });

  final String id;
  final String message;
  final String? contactInfo;
  final String timestamp;
  final Map<String, dynamic> metadata;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final collectionEquals = const DeepCollectionEquality().equals;
    return other is FeedbackEntity &&
        other.id == id &&
        other.message == message &&
        other.contactInfo == contactInfo &&
        other.timestamp == timestamp &&
        collectionEquals(other.metadata, metadata);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        message.hashCode ^
        contactInfo.hashCode ^
        timestamp.hashCode ^
        const DeepCollectionEquality().hash(metadata);
  }
}
