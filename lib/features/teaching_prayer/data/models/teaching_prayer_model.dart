import 'package:flutter/foundation.dart';
import 'package:sana/features/teaching_prayer/constants/teaching_prayer_keys.dart';

@immutable
class TeachingPrayerSectionModel {
  const TeachingPrayerSectionModel({
    required this.id,
    required this.title,
    required this.topics,
  });

  factory TeachingPrayerSectionModel.fromJson(Map<String, dynamic> json) {
    final category = json[TeachingPrayerKeys.category] as String? ?? '';
    return TeachingPrayerSectionModel(
      id: category,
      title: category,
      topics:
          (json[TeachingPrayerKeys.topics] as List<dynamic>?)
              ?.map(
                (e) => TeachingPrayerTopicModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }

  final String id;
  final String title;
  final List<TeachingPrayerTopicModel> topics;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TeachingPrayerSectionModel) return false;

    if (id != other.id || title != other.title) return false;
    if (topics.length != other.topics.length) return false;
    for (var i = 0; i < topics.length; i++) {
      if (topics[i] != other.topics[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ topics.hashCode;
}

@immutable
class TeachingPrayerTopicModel {
  const TeachingPrayerTopicModel({
    required this.id,
    required this.title,
    required this.content,
  });

  factory TeachingPrayerTopicModel.fromJson(Map<String, dynamic> json) {
    final title = json[TeachingPrayerKeys.title] as String? ?? '';
    final content = json[TeachingPrayerKeys.content] as String? ?? '';
    return TeachingPrayerTopicModel(
      id: title,
      title: title,
      content: content,
    );
  }

  final String id;
  final String title;
  final String content;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TeachingPrayerTopicModel) return false;

    if (id != other.id || title != other.title || content != other.content) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ content.hashCode;
}
