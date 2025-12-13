class TeachingPrayerSection {
  final String category;
  final List<TeachingPrayerTopic> topics;

  TeachingPrayerSection({required this.category, required this.topics});

  factory TeachingPrayerSection.fromJson(Map<String, dynamic> json) {
    return TeachingPrayerSection(
      category: json['category'] ?? '',
      topics:
          (json['topics'] as List<dynamic>?)
              ?.map((e) => TeachingPrayerTopic.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class TeachingPrayerTopic {
  final String title;
  final String content;

  TeachingPrayerTopic({required this.title, required this.content});

  factory TeachingPrayerTopic.fromJson(Map<String, dynamic> json) {
    return TeachingPrayerTopic(
      title: json['title'] ?? '',
      content: json['content'] ?? '',
    );
  }
}
