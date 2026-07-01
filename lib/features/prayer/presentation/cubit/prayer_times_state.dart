import 'package:flutter/foundation.dart';
import 'package:sana/core/error/error.dart';
import 'package:sana/features/prayer/presentation/models/prayer_display_model.dart';
import 'package:sana/features/prayer/domain/entities/prayer_time_status.dart';
import 'package:sana/features/prayer/domain/entities/prayer_times_entity.dart';
import 'package:sana/features/prayer/domain/entities/religious_event_entity.dart';
import 'package:sana/features/prayer/domain/entities/sunnah_times_entity.dart';
import 'package:sana/features/prayer/domain/entities/user_prayer_times_settings_entity.dart';

@immutable
sealed class PrayerTimesState {
  const PrayerTimesState({required this.settings});

  const factory PrayerTimesState.initial({
    required UserPrayerTimesSettings settings,
  }) = PrayerTimesInitial;

  const factory PrayerTimesState.loading({
    required UserPrayerTimesSettings settings,
  }) = PrayerTimesLoading;

  const factory PrayerTimesState.failure({
    required UserPrayerTimesSettings settings,
    required Failure failure,
  }) = PrayerTimesError;

  const factory PrayerTimesState.success({
    required List<PrayerDisplayModel> prayers,
    required UserPrayerTimesSettings settings,
    Duration? timeRemaining,
    SunnahTimesEntity? sunnahTimes,
    PrayerTimesEntity? originPrayerTimes,
    ReligiousEventEntity? currentEvent,
    bool isEventToday,
    PrayerTimeStatus? currentStatus,
  }) = PrayerTimesLoaded;

  final UserPrayerTimesSettings settings;

  PrayerTimesState copyWith({UserPrayerTimesSettings? settings});
}

@immutable
class PrayerTimesInitial extends PrayerTimesState {
  const PrayerTimesInitial({required super.settings});

  @override
  PrayerTimesInitial copyWith({UserPrayerTimesSettings? settings}) {
    return PrayerTimesInitial(settings: settings ?? this.settings);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrayerTimesInitial &&
          runtimeType == other.runtimeType &&
          settings == other.settings;

  @override
  int get hashCode => settings.hashCode;
}

@immutable
class PrayerTimesLoading extends PrayerTimesState {
  const PrayerTimesLoading({required super.settings});

  @override
  PrayerTimesLoading copyWith({UserPrayerTimesSettings? settings}) {
    return PrayerTimesLoading(settings: settings ?? this.settings);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrayerTimesLoading &&
          runtimeType == other.runtimeType &&
          settings == other.settings;

  @override
  int get hashCode => settings.hashCode;
}

@immutable
class PrayerTimesLoaded extends PrayerTimesState {
  const PrayerTimesLoaded({
    required this.prayers,
    required super.settings,
    this.timeRemaining,
    this.sunnahTimes,
    this.originPrayerTimes,
    this.currentEvent,
    this.isEventToday = true,
    this.currentStatus,
  });

  final List<PrayerDisplayModel> prayers;
  final Duration? timeRemaining;
  final SunnahTimesEntity? sunnahTimes;
  final PrayerTimesEntity? originPrayerTimes;
  final ReligiousEventEntity? currentEvent;
  final bool isEventToday;
  final PrayerTimeStatus? currentStatus;

  @override
  PrayerTimesLoaded copyWith({
    UserPrayerTimesSettings? settings,
    List<PrayerDisplayModel>? prayers,
    Duration? timeRemaining,
    SunnahTimesEntity? sunnahTimes,
    PrayerTimesEntity? originPrayerTimes,
    ReligiousEventEntity? currentEvent,
    bool? isEventToday,
    PrayerTimeStatus? currentStatus,
  }) {
    return PrayerTimesLoaded(
      prayers: prayers ?? this.prayers,
      settings: settings ?? this.settings,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      sunnahTimes: sunnahTimes ?? this.sunnahTimes,
      originPrayerTimes: originPrayerTimes ?? this.originPrayerTimes,
      currentEvent: currentEvent ?? this.currentEvent,
      isEventToday: isEventToday ?? this.isEventToday,
      currentStatus: currentStatus ?? this.currentStatus,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrayerTimesLoaded &&
          runtimeType == other.runtimeType &&
          prayers == other.prayers &&
          settings == other.settings &&
          timeRemaining == other.timeRemaining &&
          sunnahTimes == other.sunnahTimes &&
          originPrayerTimes == other.originPrayerTimes &&
          currentEvent == other.currentEvent &&
          isEventToday == other.isEventToday &&
          currentStatus == other.currentStatus;

  @override
  int get hashCode => Object.hash(
    prayers,
    settings,
    timeRemaining,
    sunnahTimes,
    originPrayerTimes,
    currentEvent,
    isEventToday,
    currentStatus,
  );

  @override
  String toString() =>
      'PrayerTimesLoaded(prayersCount: ${prayers.length}, status: $currentStatus)';
}

@immutable
class PrayerTimesError extends PrayerTimesState {
  const PrayerTimesError({required super.settings, required this.failure});

  final Failure failure;

  @override
  PrayerTimesError copyWith({
    UserPrayerTimesSettings? settings,
    Failure? failure,
  }) {
    return PrayerTimesError(
      settings: settings ?? this.settings,
      failure: failure ?? this.failure,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrayerTimesError &&
          runtimeType == other.runtimeType &&
          settings == other.settings &&
          failure == other.failure;

  @override
  int get hashCode => settings.hashCode ^ failure.hashCode;

  @override
  String toString() => 'PrayerTimesError(failure: $failure)';
}
