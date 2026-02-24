part of 'prayer_times_cubit.dart';

enum PrayerTimesStatus { initial, loading, success, failure }

class PrayerTimesState extends Equatable {
  const PrayerTimesState({
    required this.prayers,
    required this.settings,
    this.status = PrayerTimesStatus.initial,
    this.timeRemaining,
    this.sunnahTimes,
    this.failure,
  });

  factory PrayerTimesState.initial() => PrayerTimesState(
    prayers: const [],
    settings: UserPrayerTimesSettings.defaultSettings(),
  );

  final List<PrayerDisplayModel> prayers;
  final Duration? timeRemaining;
  final SunnahTimes? sunnahTimes;
  final UserPrayerTimesSettings settings;
  final PrayerTimesStatus status;
  final Failure? failure;

  PrayerTimesState copyWith({
    List<PrayerDisplayModel>? prayers,
    Duration? timeRemaining,
    SunnahTimes? sunnahTimes,
    UserPrayerTimesSettings? settings,
    PrayerTimesStatus? status,
    Failure? failure,
  }) => PrayerTimesState(
    prayers: prayers ?? this.prayers,
    timeRemaining: timeRemaining ?? this.timeRemaining,
    sunnahTimes: sunnahTimes ?? this.sunnahTimes,
    settings: settings ?? this.settings,
    status: status ?? this.status,
    failure: failure ?? this.failure,
  );

  @override
  List<Object?> get props => [
    prayers,
    timeRemaining,
    sunnahTimes,
    settings,
    status,
    failure,
  ];
}
