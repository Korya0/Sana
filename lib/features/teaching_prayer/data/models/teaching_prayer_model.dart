class TeachingPrayerSection {
  final String category;
  final List<TeachingPrayerTopic> topics;

  const TeachingPrayerSection({required this.category, required this.topics});

  factory TeachingPrayerSection.fromJson(Map<String, dynamic> json) {
    return TeachingPrayerSection(
      category: json['category'] as String,
      topics: (json['topics'] as List)
          .map((e) => TeachingPrayerTopic.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'topics': topics.map((e) => e.toJson()).toList(),
    };
  }
}

class TeachingPrayerTopic {
  final String title;
  final String content;

  const TeachingPrayerTopic({required this.title, required this.content});

  factory TeachingPrayerTopic.fromJson(Map<String, dynamic> json) {
    return TeachingPrayerTopic(
      title: json['title'] as String,
      content: json['content'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'content': content};
  }
}
