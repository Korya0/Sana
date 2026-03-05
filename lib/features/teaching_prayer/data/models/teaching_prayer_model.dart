import 'package:sana/core/constants/json_keys.dart';

class TeachingPrayerSection {
  const TeachingPrayerSection({required this.category, required this.topics});

  factory TeachingPrayerSection.fromJson(Map<String, dynamic> json) {
    return TeachingPrayerSection(
      category: json[JsonKeys.category] as String,
      topics: (json[JsonKeys.topics] as List)
          .map((e) => TeachingPrayerTopic.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
  final String category;
  final List<TeachingPrayerTopic> topics;

  Map<String, dynamic> toJson() {
    return {
      JsonKeys.category: category,
      JsonKeys.topics: topics.map((e) => e.toJson()).toList(),
    };
  }
}

class TeachingPrayerTopic {
  const TeachingPrayerTopic({required this.title, required this.content});

  factory TeachingPrayerTopic.fromJson(Map<String, dynamic> json) {
    return TeachingPrayerTopic(
      title: json[JsonKeys.title] as String,
      content: json[JsonKeys.content] as String,
    );
  }
  final String title;
  final String content;

  Map<String, dynamic> toJson() {
    return {JsonKeys.title: title, JsonKeys.content: content};
  }
}
