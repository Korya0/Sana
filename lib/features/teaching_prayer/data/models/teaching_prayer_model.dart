import 'package:sana/features/teaching_prayer/constants/teaching_prayer_keys.dart';
import 'package:sana/features/teaching_prayer/utils/teaching_content_parser.dart';

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
}

class TeachingPrayerTopicModel {
  const TeachingPrayerTopicModel({
    required this.id,
    required this.title,
    required this.content,
    required this.points,
  });

  factory TeachingPrayerTopicModel.fromJson(Map<String, dynamic> json) {
    final title = json[TeachingPrayerKeys.title] as String? ?? '';
    final content = json[TeachingPrayerKeys.content] as String? ?? '';
    return TeachingPrayerTopicModel(
      id: title,
      title: title,
      content: content,
      points: TeachingContentParser.parseContent(content),
    );
  }

  final String id;
  final String title;
  final String content;
  final List<TeachingPointModel> points;
}
