import 'package:sana/features/teaching_prayer/data/models/teaching_prayer_model.dart';

sealed class TeachingPrayerState {
  const TeachingPrayerState();
}

class TeachingPrayerInitial extends TeachingPrayerState {
  const TeachingPrayerInitial();
}

class TeachingPrayerLoading extends TeachingPrayerState {
  const TeachingPrayerLoading();
}

class TeachingPrayerSuccess extends TeachingPrayerState {
  const TeachingPrayerSuccess(this.sections);
  final List<TeachingPrayerSectionModel> sections;
}

class TeachingPrayerError extends TeachingPrayerState {
  const TeachingPrayerError(this.message);
  final String message;
}
