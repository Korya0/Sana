import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/services/date_gregorian_and_hijri/cubit/app_date_cubit.dart';
import 'package:sana/core/services/location/cubit/location_permission/location_cubit.dart';
import 'package:sana/core/services/location/cubit/location_permission/location_state.dart';
import 'package:sana/features/prayer/data/models/user_prayer_times_settings.dart';
import 'package:sana/features/prayer/data/services/prayer_times_service.dart';
import 'package:sana/features/prayer/data/services/user_settings_service.dart';
import 'package:sana/features/prayer/domain/helpers/prayer_name_provider.dart';
import 'package:sana/features/prayer/domain/models/prayer_display_model.dart';

part 'prayer_times_state.dart';

class PrayerTimesCubit extends Cubit<PrayerTimesState>
    with WidgetsBindingObserver {
  final PrayerTimesService prayerTimesService;
  final UserSettingsService settingsService;
  final AppDateCubit appDateCubit;
  final LocationCubit locationCubit;
  Timer? _timer;
  StreamSubscription? _locationSubscription;
  StreamSubscription? _dateSubscription;

  // Default locale - can be changed for localization
  String _currentLocale = 'ar';

  PrayerTimesCubit({
    required this.prayerTimesService,
    required this.settingsService,
    required this.appDateCubit,
    required this.locationCubit,
  }) : super(PrayerTimesState.initial()) {
    WidgetsBinding.instance.addObserver(this);
    _setupListeners();
  }

  void _setupListeners() {
    _locationSubscription = locationCubit.stream.listen((locationState) {
      if (locationState is LocationSuccess) {
        _calculatePrayerTimes();
      }
    });

    _dateSubscription = appDateCubit.stream.listen((_) {
      _calculatePrayerTimes();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App came to foreground, refresh to ensure timer/UI is synced
      _calculatePrayerTimes();
    }
  }

  /// Update locale for prayer names
  void setLocale(String locale) {
    _currentLocale = locale;
    _calculatePrayerTimes();
  }

  Future<void> loadSettings() async {
    final settings = await settingsService.loadSettings();
    emit(state.copyWith(settings: settings));

    // Defer calculation slightly to avoid blocking the main thread during navigation/startup
    Future.microtask(_calculatePrayerTimes);
  }

  void updateSettings(UserPrayerTimesSettings settings) async {
    await settingsService.saveSettings(settings);
    emit(state.copyWith(settings: settings));
    _calculatePrayerTimes();
  }

  void _calculatePrayerTimes() async {
    final baseDate = appDateCubit.currentDate;
    final now = DateTime.now();

    // Get coordinates from service (which reads from SharedPref)
    final coords = prayerTimesService.getCoordinates();

    // Get prayer times from service (calculation only)
    final prayerTimes = prayerTimesService.calculatePrayerTimes(
      settings: state.settings,
      coords: coords,
      dateTime: baseDate,
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

    // Find current and next prayer using real-time 'now'
    for (int i = 0; i < prayerTypes.length; i++) {
      final prayer = prayerTypes[i];
      final time = _getPrayerTime(prayerTimes, prayer);

      // If 'now' is strictly before the prayer time, this is the next one
      if (now.isBefore(time)) {
        nextPrayerType = prayer;
        nextPrayerTime = time;
        if (i > 0) {
          currentPrayerType = prayerTypes[i - 1];
        } else {
          // If Fajr is next, current is late night (Isha of yesterday)
          currentPrayerType = Prayer.isha;
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
          time.year == nextPrayerTime.year &&
          time.month == nextPrayerTime.month &&
          time.day == nextPrayerTime.day &&
          time.hour == nextPrayerTime.hour &&
          time.minute == nextPrayerTime.minute;

      return PrayerDisplayModel(
        type: prayer,
        time: time,
        displayName: displayName,
        isCurrent: prayer == currentPrayerType,
        isNext: isThisNext,
        sunnahTimes: sunnahTimes,
      );
    }).toList();

    // If next prayer is tomorrow's Fajr, replace today's Fajr with tomorrow's for display
    if (nextPrayerType == Prayer.fajr &&
        nextPrayerTime != null &&
        nextPrayerTime.day != now.day) {
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

    // Calculate time remaining using real-time 'now'
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
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _locationSubscription?.cancel();
    _dateSubscription?.cancel();
    return super.close();
  }
}
