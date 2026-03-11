import 'package:sana/features/teaching_prayer/data/constants/teaching_prayer_keys.dart';

class TeachingPrayerSection {
  const TeachingPrayerSection({required this.category, required this.topics});

  factory TeachingPrayerSection.fromJson(Map<String, dynamic> json) {
    return TeachingPrayerSection(
      category: json[TeachingPrayerKeys.category] as String,
      topics: (json[TeachingPrayerKeys.topics] as List)
          .map((e) => TeachingPrayerTopic.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
  final String category;
  final List<TeachingPrayerTopic> topics;

  Map<String, dynamic> toJson() {
    return {
      TeachingPrayerKeys.category: category,
      TeachingPrayerKeys.topics: topics.map((e) => e.toJson()).toList(),
    };
  }
}

class TeachingPrayerTopic {
  const TeachingPrayerTopic({required this.title, required this.content});

  factory TeachingPrayerTopic.fromJson(Map<String, dynamic> json) {
    return TeachingPrayerTopic(
      title: json[TeachingPrayerKeys.title] as String,
      content: json[TeachingPrayerKeys.content] as String,
    );
  }
  final String title;
  final String content;

  Map<String, dynamic> toJson() {
    return {
      TeachingPrayerKeys.title: title,
      TeachingPrayerKeys.content: content
    };
  }
}
