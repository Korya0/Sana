import 'package:flutter/foundation.dart';
import 'package:sana/features/teaching_prayer/domain/entities/teaching_prayer_entity.dart';

@immutable
sealed class TeachingPrayerState {
  const TeachingPrayerState();
}

@immutable
class TeachingPrayerInitial extends TeachingPrayerState {
  const TeachingPrayerInitial();

  @override
  bool operator ==(Object other) => identical(this, other) || other is TeachingPrayerInitial;

  @override
  int get hashCode => runtimeType.hashCode;
}

@immutable
class TeachingPrayerLoading extends TeachingPrayerState {
  const TeachingPrayerLoading();

  @override
  bool operator ==(Object other) => identical(this, other) || other is TeachingPrayerLoading;

  @override
  int get hashCode => runtimeType.hashCode;
}

@immutable
class TeachingPrayerSuccess extends TeachingPrayerState {
  const TeachingPrayerSuccess(this.sections);
  final List<TeachingPrayerSectionEntity> sections;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TeachingPrayerSuccess) return false;
    if (sections.length != other.sections.length) return false;
    for (var i = 0; i < sections.length; i++) {
      if (sections[i] != other.sections[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => sections.hashCode;
}

@immutable
class TeachingPrayerError extends TeachingPrayerState {
  const TeachingPrayerError(this.message);
  final String message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeachingPrayerError && other.message == message;

  @override
  int get hashCode => message.hashCode;
}
