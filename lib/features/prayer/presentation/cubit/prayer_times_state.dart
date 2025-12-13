part of 'prayer_times_cubit.dart';

class PrayerTimesState extends Equatable {
  final PrayerTimes? prayerTimes;
  final SunnahTimes? sunnahTimes;
  final Prayer? currentPrayer;
  final Prayer? nextPrayer;
  final String countdownNextPrayer;
  final UserPrayerTimesSettings settings;
  final String? nextPrayerName;

  const PrayerTimesState({
    this.prayerTimes,
    this.sunnahTimes,
    this.currentPrayer,
    this.nextPrayer,
    this.nextPrayerName,
    this.countdownNextPrayer = "00:00:00",
    required this.settings,
  });

  factory PrayerTimesState.initial() =>
      PrayerTimesState(settings: UserPrayerTimesSettings.defaultSettings());

  PrayerTimesState copyWith({
    PrayerTimes? prayerTimes,
    SunnahTimes? sunnahTimes,
    Prayer? currentPrayer,
    Prayer? nextPrayer,
    String? countdownNextPrayer,
    UserPrayerTimesSettings? settings,
    String? nextPrayerName,

    String? hijriDate,
    String? gregorianDate,
  }) => PrayerTimesState(
    prayerTimes: prayerTimes ?? this.prayerTimes,
    sunnahTimes: sunnahTimes ?? this.sunnahTimes,
    currentPrayer: currentPrayer ?? this.currentPrayer,
    nextPrayer: nextPrayer ?? this.nextPrayer,
    countdownNextPrayer: countdownNextPrayer ?? this.countdownNextPrayer,
    settings: settings ?? this.settings,
    nextPrayerName: nextPrayerName ?? this.nextPrayerName,
  );

  @override
  List<Object?> get props => [
    prayerTimes,
    sunnahTimes,
    currentPrayer,
    nextPrayer,
    countdownNextPrayer,
    settings,
    nextPrayerName,
  ];
}
