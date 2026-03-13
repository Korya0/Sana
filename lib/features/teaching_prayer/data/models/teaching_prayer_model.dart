import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sana/features/teaching_prayer/data/constants/teaching_prayer_keys.dart';

part 'teaching_prayer_model.freezed.dart';

@freezed
class TeachingPrayerSection with _$TeachingPrayerSection {
  const factory TeachingPrayerSection({
    required String category,
    required List<TeachingPrayerTopic> topics,
  }) = _TeachingPrayerSection;

  factory TeachingPrayerSection.fromJson(Map<String, dynamic> json) {
    return TeachingPrayerSection(
      category: json[TeachingPrayerKeys.category] as String,
      topics: (json[TeachingPrayerKeys.topics] as List)
          .map((e) => TeachingPrayerTopic.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

@freezed
class TeachingPrayerTopic with _$TeachingPrayerTopic {
  const factory TeachingPrayerTopic({
    required String title,
    required String content,
  }) = _TeachingPrayerTopic;

  factory TeachingPrayerTopic.fromJson(Map<String, dynamic> json) {
    return TeachingPrayerTopic(
      title: json[TeachingPrayerKeys.title] as String,
      content: json[TeachingPrayerKeys.content] as String,
    );
  }
}
