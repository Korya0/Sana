class TeachingPrayerSection {
  const TeachingPrayerSection({required this.category, required this.topics});

  factory TeachingPrayerSection.fromJson(Map<String, dynamic> json) {
    return TeachingPrayerSection(
      category: json['category'] as String,
      topics: (json['topics'] as List)
          .map((e) => TeachingPrayerTopic.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
  final String category;
  final List<TeachingPrayerTopic> topics;

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'topics': topics.map((e) => e.toJson()).toList(),
    };
  }
}

class TeachingPrayerTopic {
  const TeachingPrayerTopic({required this.title, required this.content});

  factory TeachingPrayerTopic.fromJson(Map<String, dynamic> json) {
    return TeachingPrayerTopic(
      title: json['title'] as String,
      content: json['content'] as String,
    );
  }
  final String title;
  final String content;

  Map<String, dynamic> toJson() {
    return {'title': title, 'content': content};
  }
}
