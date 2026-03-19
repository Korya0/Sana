import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sana/features/teaching_prayer/data/models/teaching_prayer_model.dart';

part 'teaching_prayer_state.freezed.dart';

@freezed
class TeachingPrayerState with _$TeachingPrayerState {
  const factory TeachingPrayerState.initial() = TeachingPrayerInitial;
  const factory TeachingPrayerState.loading() = TeachingPrayerLoading;
  const factory TeachingPrayerState.loaded(
    List<TeachingPrayerSection> sections,
  ) = TeachingPrayerLoaded;
  const factory TeachingPrayerState.error(String message) = TeachingPrayerError;
}
