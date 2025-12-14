part of 'prayer_times_cubit.dart';

class PrayerTimesState extends Equatable {
  final PrayerTimes? prayerTimes;
  final SunnahTimes? sunnahTimes;
  final Prayer? currentPrayer;
  final Prayer? nextPrayer;
  final DateTime? nextPrayerTime;
  final DateTime? previousPrayerTime;
  final UserPrayerTimesSettings settings;

  const PrayerTimesState({
    this.prayerTimes,
    this.sunnahTimes,
    this.currentPrayer,
    this.nextPrayer,
    this.nextPrayerTime,
    this.previousPrayerTime,
    required this.settings,
  });

  factory PrayerTimesState.initial() =>
      PrayerTimesState(settings: UserPrayerTimesSettings.defaultSettings());

  PrayerTimesState copyWith({
    PrayerTimes? prayerTimes,
    SunnahTimes? sunnahTimes,
    Prayer? currentPrayer,
    Prayer? nextPrayer,
    DateTime? nextPrayerTime,
    DateTime? previousPrayerTime,
    UserPrayerTimesSettings? settings,
  }) => PrayerTimesState(
    prayerTimes: prayerTimes ?? this.prayerTimes,
    sunnahTimes: sunnahTimes ?? this.sunnahTimes,
    currentPrayer: currentPrayer ?? this.currentPrayer,
    nextPrayer: nextPrayer ?? this.nextPrayer,
    nextPrayerTime: nextPrayerTime ?? this.nextPrayerTime,
    previousPrayerTime: previousPrayerTime ?? this.previousPrayerTime,
    settings: settings ?? this.settings,
  );

  @override
  List<Object?> get props => [
    prayerTimes,
    sunnahTimes,
    currentPrayer,
    nextPrayer,
    nextPrayerTime,
    previousPrayerTime,
    settings,
  ];
}
