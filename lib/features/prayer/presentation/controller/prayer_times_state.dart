part of 'prayer_times_cubit.dart';

@freezed
class PrayerTimesState with _$PrayerTimesState {
  const PrayerTimesState._();

  const factory PrayerTimesState.initial({
    required UserPrayerTimesSettings settings,
  }) = PrayerTimesInitial;

  const factory PrayerTimesState.loading({
    required UserPrayerTimesSettings settings,
  }) = PrayerTimesLoading;

  const factory PrayerTimesState.success({
    required List<PrayerDisplayModel> prayers,
    required UserPrayerTimesSettings settings,
    Duration? timeRemaining,
    SunnahTimes? sunnahTimes,
    PrayerTimes? originPrayerTimes,
    ReligiousEventModel? currentEvent,
    @Default(true) bool isEventToday,
    PrayerTimeStatus? currentStatus,
  }) = PrayerTimesLoaded;

  const factory PrayerTimesState.failure({
    required UserPrayerTimesSettings settings,
    required Failure failure,
  }) = PrayerTimesError;
}
