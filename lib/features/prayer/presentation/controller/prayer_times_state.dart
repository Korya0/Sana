part of 'prayer_times_cubit.dart';

enum PrayerTimesStatus { initial, loading, success, failure }

class PrayerTimesState extends Equatable {
  const PrayerTimesState({
    required this.prayers,
    required this.settings,
    this.status = PrayerTimesStatus.initial,
    this.timeRemaining,
    this.sunnahTimes,
    this.originPrayerTimes, // Adhan PrayerTimes object
    this.failure,
  });

  factory PrayerTimesState.initial() => PrayerTimesState(
    prayers: const [],
    settings: UserPrayerTimesSettings.defaultSettings(),
  );

  final List<PrayerDisplayModel> prayers;
  final Duration? timeRemaining;
  final SunnahTimes? sunnahTimes;
  final PrayerTimes? originPrayerTimes;
  final UserPrayerTimesSettings settings;
  final PrayerTimesStatus status;
  final Failure? failure;

  PrayerTimesState copyWith({
    List<PrayerDisplayModel>? prayers,
    Duration? timeRemaining,
    SunnahTimes? sunnahTimes,
    PrayerTimes? originPrayerTimes,
    UserPrayerTimesSettings? settings,
    PrayerTimesStatus? status,
    Failure? failure,
  }) {
    return PrayerTimesState(
      prayers: prayers ?? this.prayers,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      sunnahTimes: sunnahTimes ?? this.sunnahTimes,
      originPrayerTimes: originPrayerTimes ?? this.originPrayerTimes,
      settings: settings ?? this.settings,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
    prayers,
    timeRemaining,
    sunnahTimes,
    originPrayerTimes,
    settings,
    status,
    failure,
  ];
}
