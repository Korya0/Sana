import 'dart:async';
import 'package:adhan/adhan.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/services/date_gregorian_and_hijri/cubit/app_date_cubit.dart';

import 'package:sana/features/prayer/data/models/user_prayer_times_settings.dart';
import 'package:sana/features/prayer/data/services/prayer_times_service.dart';
import 'package:sana/features/prayer/data/services/user_settings_service.dart';
part 'prayer_times_state.dart';

class PrayerTimesCubit extends Cubit<PrayerTimesState> {
  final PrayerTimesService prayerTimesService;
  final UserSettingsService settingsService;
  final Coordinates coords;
  final AppDateCubit appDateCubit;
  Timer? _timer;

  PrayerTimesCubit({
    required this.prayerTimesService,
    required this.settingsService,
    required this.appDateCubit,
    required this.coords,
  }) : super(PrayerTimesState.initial());

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
    final prayerTimes = prayerTimesService.calculatePrayerTimes(
      settings: state.settings,
      coords: coords,
      dateTime: appDateCubit.currentDate,
    );
    final dateToCheck = appDateCubit.currentDate;
    final sunnahTimes = prayerTimesService.calculateSunnahTimes(
      prayerTimes: prayerTimes,
    );
    final current = prayerTimesService.getCurrentPrayer(prayerTimes);
    final next = prayerTimesService.getNextPrayer(
      prayerTimes,
      time: dateToCheck,
    );

    final nextPrayerTime = prayerTimesService.getNextPrayerTime(
      prayerTimes,
      time: dateToCheck,
    );
    final previousPrayerTime = prayerTimesService.getPreviousPrayerTime(
      prayerTimes,
      time: dateToCheck,
    );

    emit(
      state.copyWith(
        prayerTimes: prayerTimes,
        sunnahTimes: sunnahTimes,
        currentPrayer: current,
        nextPrayer: next,
        nextPrayerTime: nextPrayerTime,
        previousPrayerTime: previousPrayerTime,
      ),
    );

    _scheduleNextUpdate(nextPrayerTime);
  }

  void _scheduleNextUpdate(DateTime nextPrayerTime) {
    _timer?.cancel();
    final now = appDateCubit.currentDate;
    final duration = nextPrayerTime.difference(now);

    // Add a small buffer (e.g. 2 seconds) to ensure we are strictly after the prayer time
    final scheduleDuration = duration + const Duration(seconds: 2);

    if (scheduleDuration.isNegative) {
      // If negative, maybe we are just slightly past?
      // Rethink: If nextPrayerTime is computed correctly (in future), this shouldn't happen.
      // But if it does, schedule immediately.
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
