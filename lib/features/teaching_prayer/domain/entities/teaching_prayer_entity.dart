import 'package:flutter/foundation.dart';

@immutable
class TeachingPrayerSectionEntity {
  const TeachingPrayerSectionEntity({
    required this.id,
    required this.title,
    required this.topics,
  });

  final String id;
  final String title;
  final List<TeachingPrayerTopicEntity> topics;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TeachingPrayerSectionEntity) return false;

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
class TeachingPrayerTopicEntity {
  const TeachingPrayerTopicEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.points,
  });

  final String id;
  final String title;
  final String content;
  final List<TeachingPointEntity> points;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TeachingPrayerTopicEntity) return false;

    if (id != other.id || title != other.title || content != other.content) {
      return false;
    }
    if (points.length != other.points.length) return false;
    for (var i = 0; i < points.length; i++) {
      if (points[i] != other.points[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode =>
      id.hashCode ^ title.hashCode ^ content.hashCode ^ points.hashCode;
}

@immutable
class TeachingPointEntity {
  const TeachingPointEntity({
    required this.number,
    required this.spans,
  });

  final String number;
  final List<HighlightedSpanEntity> spans;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TeachingPointEntity) return false;

    if (number != other.number) return false;
    if (spans.length != other.spans.length) return false;
    for (var i = 0; i < spans.length; i++) {
      if (spans[i] != other.spans[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => number.hashCode ^ spans.hashCode;
}

@immutable
class HighlightedSpanEntity {
  const HighlightedSpanEntity({
    required this.text,
    required this.isHighlighted,
  });

  final String text;
  final bool isHighlighted;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HighlightedSpanEntity &&
        other.text == text &&
        other.isHighlighted == isHighlighted;
  }

  @override
  int get hashCode => text.hashCode ^ isHighlighted.hashCode;
}
