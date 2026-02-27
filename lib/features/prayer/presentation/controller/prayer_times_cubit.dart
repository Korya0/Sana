import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/features/app_date/presentation/controller/app_date_cubit.dart';
import 'package:sana/features/app_date/presentation/controller/app_date_state.dart';
import 'package:sana/features/location_manager/presentation/controller/location_permission/location_cubit.dart';
import 'package:sana/features/prayer/data/models/user_prayer_times_settings.dart';
import 'package:sana/features/prayer/data/repositories/prayer_repository.dart';
import 'package:sana/features/prayer/data/services/prayer_times_service.dart';
import 'package:sana/features/prayer/data/services/religious_events_service.dart';
import 'package:sana/features/prayer/data/services/user_settings_service.dart';
import 'package:sana/features/prayer/domain/helpers/prayer_name_provider.dart';
import 'package:sana/features/prayer/domain/models/prayer_display_model.dart';
import 'package:sana/features/prayer/utils/prayer_time_status_calculator.dart';

part 'prayer_times_state.dart';

class PrayerTimesCubit extends Cubit<PrayerTimesState>
    with WidgetsBindingObserver {
  PrayerTimesCubit({
    required this.prayerTimesService,
    required this.prayerRepository,
    required this.settingsService,
    required this.appDateCubit,
    required this.locationCubit,
    required this.religiousEventsService,
  }) : super(PrayerTimesState.initial()) {
    WidgetsBinding.instance.addObserver(this);
    _setupListeners();
    unawaited(loadSettings());
  }

  final PrayerTimesService prayerTimesService;
  final IPrayerRepository prayerRepository;
  final UserSettingsService settingsService;
  final AppDateCubit appDateCubit;
  final LocationCubit locationCubit;
  final ReligiousEventsService religiousEventsService;
  Timer? _timer;
  StreamSubscription<LocationState>? _locationSubscription;
  StreamSubscription<AppDateState>? _dateSubscription;

  // Default locale - can be changed for localization
  String _currentLocale = 'ar';

  void _setupListeners() {
    _locationSubscription = locationCubit.stream.listen((locationState) {
      if (locationState is LocationSuccess) {
        unawaited(_calculatePrayerTimes());
      }
    });

    _dateSubscription = appDateCubit.stream.listen((_) {
      unawaited(_calculatePrayerTimes());
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App came to foreground, refresh to ensure timer/UI is synced
      unawaited(_calculatePrayerTimes());
    }
  }

  /// Update locale for prayer names
  void setLocale(String locale) {
    _currentLocale = locale;
    unawaited(_calculatePrayerTimes());
  }

  /// Manually trigger recalculation of prayer times (useful for UI timer crossing 00:00:00)
  void refresh() {
    unawaited(_calculatePrayerTimes());
  }

  Future<void> loadSettings() async {
    final settings = await settingsService.loadSettings();
    emit(state.copyWith(settings: settings));

    // Defer calculation slightly to avoid blocking the main thread during navigation/startup
    unawaited(Future.microtask(_calculatePrayerTimes));
  }

  Future<void> updateSettings(UserPrayerTimesSettings settings) async {
    await settingsService.saveSettings(settings);
    emit(state.copyWith(settings: settings));
    unawaited(_calculatePrayerTimes());
  }

  Future<void> _calculatePrayerTimes() async {
    final now = DateTime.now();
    final baseDate = appDateCubit.state.date.gregorian;

    final coordsResult = prayerRepository.getCoordinates();

    coordsResult.fold(
      (failure) => emit(
        state.copyWith(status: PrayerTimesStatus.failure, failure: failure),
      ),
      (coords) {
        final prayerTimesResult = prayerRepository.getPrayerTimes(
          settings: state.settings,
          coords: coords,
          dateTime: baseDate,
        );

        prayerTimesResult.fold(
          (failure) => emit(
            state.copyWith(status: PrayerTimesStatus.failure, failure: failure),
          ),
          (prayerTimes) async {
            final sunnahTimes = prayerTimesService.calculateSunnahTimes(
              prayerTimes: prayerTimes,
            );

            final prayerState = prayerTimesService
                .calculatePrayerStateWithDetails(
                  prayerTimes: prayerTimes,
                  now: now,
                );

            final nextPrayerTime = _resolveNextPrayerTime(
              prayerState,
              coords,
              baseDate,
            );

            final displayModels = _buildDisplayModels(
              prayerTimes,
              sunnahTimes,
              prayerState,
              nextPrayerTime,
            );

            final hijriDate = appDateCubit.state.date.hijri;

            // Fix: await the future returned by getEventForDate
            await religiousEventsService.getEventForDate(hijriDate).then((
              currentEvent,
            ) {
              final isEventToday = currentEvent?.isOccurring(hijriDate) ?? true;
              final currentStatus = PrayerTimeStatusCalculator.getStatus(
                prayerTimes: prayerTimes,
                sunnahTimes: sunnahTimes,
                now: now,
              );

              emit(
                state.copyWith(
                  status: PrayerTimesStatus.success,
                  prayers: displayModels,
                  timeRemaining:
                      nextPrayerTime?.difference(now) ?? Duration.zero,
                  sunnahTimes: sunnahTimes,
                  originPrayerTimes: prayerTimes,
                  currentEvent: currentEvent,
                  isEventToday: isEventToday,
                  currentStatus: currentStatus,
                ),
              );

              if (nextPrayerTime != null) {
                _scheduleNextUpdate(nextPrayerTime);
              }
            });
          },
        );
      },
    );
  }

  DateTime? _resolveNextPrayerTime(
    PrayerState prayerState,
    Coordinates coords,
    DateTime baseDate,
  ) {
    if (prayerState.nextPrayerTime != null) return prayerState.nextPrayerTime;

    // If no next prayer today, next is tomorrow's Fajr
    final tomorrow = baseDate.add(const Duration(days: 1));
    final tomorrowResult = prayerRepository.getPrayerTimes(
      settings: state.settings,
      coords: coords,
      dateTime: tomorrow,
    );

    return tomorrowResult.fold(
      (failure) => null,
      (tomorrowPT) => tomorrowPT.fajr,
    );
  }

  List<PrayerDisplayModel> _buildDisplayModels(
    PrayerTimes prayerTimes,
    SunnahTimes sunnahTimes,
    PrayerState prayerState,
    DateTime? resolvedNextTime,
  ) {
    final prayerTypes = [
      Prayer.fajr,
      Prayer.dhuhr,
      Prayer.asr,
      Prayer.maghrib,
      Prayer.isha,
    ];

    return prayerTypes.map((type) {
      var time = prayerTimesService.getPrayerTime(prayerTimes, type);
      final isNext = type == prayerState.nextPrayer;

      // If this is the next prayer and it's tomorrow's (e.g., Fajr after Isha), update time
      if (isNext &&
          resolvedNextTime != null &&
          resolvedNextTime.isAfter(time)) {
        time = resolvedNextTime;
      }

      return PrayerDisplayModel(
        type: type,
        time: time,
        displayName: PrayerNameProvider.getName(type, _currentLocale),
        isCurrent: type == prayerState.currentPrayer,
        isNext: isNext,
        sunnahTimes: sunnahTimes,
      );
    }).toList();
  }

  void _scheduleNextUpdate(DateTime nextTime) {
    _timer?.cancel();
    final now = DateTime.now(); // Ensure we use current real time
    final duration = nextTime.difference(now);

    final scheduleDuration = duration + const Duration(seconds: 2);

    if (scheduleDuration.isNegative) {
      _timer = Timer(const Duration(seconds: 1), _calculatePrayerTimes);
    } else {
      _timer = Timer(scheduleDuration, _calculatePrayerTimes);
    }
  }

  @override
  Future<void> close() async {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    await _locationSubscription?.cancel();
    await _dateSubscription?.cancel();
    return super.close();
  }
}
