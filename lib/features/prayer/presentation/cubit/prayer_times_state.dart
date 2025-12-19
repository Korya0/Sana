part of 'prayer_times_cubit.dart';

class PrayerTimesState extends Equatable {
  /// List of prayers ready for display in UI
  final List<PrayerDisplayModel> prayers;

  /// Time remaining until next prayer
  final Duration? timeRemaining;

  /// Sunnah times for additional prayers
  final SunnahTimes? sunnahTimes;

  /// User settings for prayer calculations
  final UserPrayerTimesSettings settings;

  const PrayerTimesState({
    required this.prayers,
    this.timeRemaining,
    this.sunnahTimes,
    required this.settings,
  });

  factory PrayerTimesState.initial() => PrayerTimesState(
    prayers: [],
    settings: UserPrayerTimesSettings.defaultSettings(),
  );

  PrayerTimesState copyWith({
    List<PrayerDisplayModel>? prayers,
    Duration? timeRemaining,
    SunnahTimes? sunnahTimes,
    UserPrayerTimesSettings? settings,
  }) => PrayerTimesState(
    prayers: prayers ?? this.prayers,
    timeRemaining: timeRemaining ?? this.timeRemaining,
    sunnahTimes: sunnahTimes ?? this.sunnahTimes,
    settings: settings ?? this.settings,
  );

  @override
  List<Object?> get props => [prayers, timeRemaining, sunnahTimes, settings];
}
