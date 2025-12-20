import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/services/date_gregorian_and_hijri/cubit/app_date_cubit.dart';
import 'package:sana/features/prayer/data/models/user_prayer_times_settings.dart';
import 'package:sana/features/prayer/data/services/prayer_times_service.dart';
import 'package:sana/features/prayer/data/services/user_settings_service.dart';
import 'package:sana/features/prayer/domain/helpers/prayer_name_provider.dart';
import 'package:sana/features/prayer/domain/models/prayer_display_model.dart';

part 'prayer_times_state.dart';

class PrayerTimesCubit extends Cubit<PrayerTimesState> {
  final PrayerTimesService prayerTimesService;
  final UserSettingsService settingsService;
  final Coordinates coords;
  final AppDateCubit appDateCubit;
  Timer? _timer;

  // Default locale - can be changed for localization
  String _currentLocale = 'ar';

  PrayerTimesCubit({
    required this.prayerTimesService,
    required this.settingsService,
    required this.appDateCubit,
    required this.coords,
  }) : super(PrayerTimesState.initial());

  /// Update locale for prayer names
  void setLocale(String locale) {
    _currentLocale = locale;
    _calculatePrayerTimes();
  }

  Future<void> loadSettings() async {
    final settings = await settingsService.loadSettings();
    emit(state.copyWith(settings: settings));
    _calculatePrayerTimes();
  }

  void updateSettings(UserPrayerTimesSettings settings) async {
    await settingsService.saveSettings(settings);
    emit(state.copyWith(settings: settings));
    _calculatePrayerTimes();
  }

  void _calculatePrayerTimes() async {
    final now = appDateCubit.currentDate;

    // Get prayer times from service (calculation only)
    final prayerTimes = prayerTimesService.calculatePrayerTimes(
      settings: state.settings,
      coords: coords,
      dateTime: now,
    );

    final sunnahTimes = prayerTimesService.calculateSunnahTimes(
      prayerTimes: prayerTimes,
    );

    // Determine current and next prayer
    Prayer? currentPrayerType;
    Prayer? nextPrayerType;
    DateTime? nextPrayerTime;

    // List of prayers to display (excluding sunrise as per user request)
    final prayerTypes = [
      Prayer.fajr,
      Prayer.dhuhr,
      Prayer.asr,
      Prayer.maghrib,
      Prayer.isha,
    ];

    // Find current and next prayer
    for (int i = 0; i < prayerTypes.length; i++) {
      final prayer = prayerTypes[i];
      final time = _getPrayerTime(prayerTimes, prayer);

      if (now.isBefore(time)) {
        nextPrayerType = prayer;
        nextPrayerTime = time;
        if (i > 0) {
          currentPrayerType = prayerTypes[i - 1];
        }
        break;
      }
    }

    // If no next prayer found today, next is tomorrow's Fajr
    if (nextPrayerType == null) {
      currentPrayerType = Prayer.isha;
      nextPrayerType = Prayer.fajr;

      final tomorrow = now.add(const Duration(days: 1));
      final tomorrowPrayerTimes = prayerTimesService.calculatePrayerTimes(
        settings: state.settings,
        coords: coords,
        dateTime: tomorrow,
      );
      nextPrayerTime = tomorrowPrayerTimes.fajr;
    }

    // Build display models for UI
    final displayModels = prayerTypes.map((prayer) {
      final time = _getPrayerTime(prayerTimes, prayer);
      final displayName = PrayerNameProvider.getName(prayer, _currentLocale);

      // Mark as next only if it's actually the next prayer AND the time matches
      final isThisNext =
          prayer == nextPrayerType &&
          nextPrayerTime != null &&
          time.isAtSameMomentAs(nextPrayerTime);

      return PrayerDisplayModel(
        type: prayer,
        time: time,
        displayName: displayName,
        isCurrent: prayer == currentPrayerType,
        isNext: isThisNext,
        sunnahTimes: sunnahTimes,
      );
    }).toList();

    // If next prayer is tomorrow's Fajr, replace today's Fajr with tomorrow's
    if (nextPrayerType == Prayer.fajr &&
        nextPrayerTime != null &&
        nextPrayerTime.isAfter(prayerTimes.isha)) {
      final tomorrowFajrName = PrayerNameProvider.getName(
        Prayer.fajr,
        _currentLocale,
      );

      // Find and replace Fajr in the list
      final fajrIndex = displayModels.indexWhere((p) => p.type == Prayer.fajr);
      if (fajrIndex != -1) {
        displayModels[fajrIndex] = PrayerDisplayModel(
          type: Prayer.fajr,
          time: nextPrayerTime,
          displayName: tomorrowFajrName,
          isCurrent: false,
          isNext: true,
          sunnahTimes: sunnahTimes,
        );
      }
    }

    // Calculate time remaining
    Duration? timeRemaining;
    if (nextPrayerTime != null) {
      timeRemaining = nextPrayerTime.difference(now);
      if (timeRemaining.isNegative) {
        timeRemaining = Duration.zero;
      }
    }

    emit(
      state.copyWith(
        prayers: displayModels,
        timeRemaining: timeRemaining,
        sunnahTimes: sunnahTimes,
      ),
    );

    // Schedule next update
    if (nextPrayerTime != null) {
      _scheduleNextUpdate(nextPrayerTime);
    }
  }

  DateTime _getPrayerTime(PrayerTimes prayerTimes, Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr:
        return prayerTimes.fajr;
      case Prayer.sunrise:
        return prayerTimes.sunrise;
      case Prayer.dhuhr:
        return prayerTimes.dhuhr;
      case Prayer.asr:
        return prayerTimes.asr;
      case Prayer.maghrib:
        return prayerTimes.maghrib;
      case Prayer.isha:
        return prayerTimes.isha;
      case Prayer.none:
        return DateTime.now();
    }
  }

  void _scheduleNextUpdate(DateTime nextPrayerTime) {
    _timer?.cancel();
    final now = appDateCubit.currentDate;
    final duration = nextPrayerTime.difference(now);

    // Add a small buffer to ensure we are strictly after the prayer time
    final scheduleDuration = duration + const Duration(seconds: 2);

    if (scheduleDuration.isNegative) {
      _timer = Timer(const Duration(seconds: 1), _calculatePrayerTimes);
    } else {
      _timer = Timer(scheduleDuration, _calculatePrayerTimes);
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
