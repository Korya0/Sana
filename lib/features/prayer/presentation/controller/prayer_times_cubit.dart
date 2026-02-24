import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/features/app_date/presentation/controller/app_date_cubit.dart';
import 'package:sana/features/app_date/presentation/controller/app_date_state.dart';
import 'package:sana/features/location_manager/presentation/controller/location_permission/location_cubit.dart';
import 'package:sana/features/location_manager/presentation/controller/location_permission/location_state.dart';
import 'package:sana/features/prayer/data/models/user_prayer_times_settings.dart';
import 'package:sana/features/prayer/data/repositories/prayer_repository.dart';
import 'package:sana/features/prayer/data/services/prayer_times_service.dart';
import 'package:sana/features/prayer/data/services/user_settings_service.dart';
import 'package:sana/features/prayer/domain/helpers/prayer_name_provider.dart';
import 'package:sana/features/prayer/domain/models/prayer_display_model.dart';

part 'prayer_times_state.dart';

class PrayerTimesCubit extends Cubit<PrayerTimesState>
    with WidgetsBindingObserver {
  PrayerTimesCubit({
    required this.prayerTimesService,
    required this.prayerRepository,
    required this.settingsService,
    required this.appDateCubit,
    required this.locationCubit,
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
    final baseDate = appDateCubit.state.date.gregorian;
    final now = DateTime.now();

    // Get coordinates from repository
    final coordsResult = prayerRepository.getCoordinates();

    coordsResult.fold(
      (failure) {
        emit(
          state.copyWith(status: PrayerTimesStatus.failure, failure: failure),
        );
      },
      (coords) {
        // Get prayer times from repository
        final prayerTimesResult = prayerRepository.getPrayerTimes(
          settings: state.settings,
          coords: coords,
          dateTime: baseDate,
        );

        prayerTimesResult.fold(
          (failure) {
            emit(
              state.copyWith(
                status: PrayerTimesStatus.failure,
                failure: failure,
              ),
            );
          },
          (prayerTimes) {
            final sunnahTimes = prayerTimesService.calculateSunnahTimes(
              prayerTimes: prayerTimes,
            );

            // List of prayers to display (excluding sunrise as per user request)
            final prayerTypes = [
              Prayer.fajr,
              Prayer.dhuhr,
              Prayer.asr,
              Prayer.maghrib,
              Prayer.isha,
            ];

            final prayerState = prayerTimesService
                .calculatePrayerStateWithDetails(
                  prayerTimes,
                  now,
                );

            final currentPrayerType = prayerState.currentPrayer;
            final nextPrayerType = prayerState.nextPrayer;
            var nextPrayerTime = prayerState.nextPrayerTime;

            // If no next prayer found today (nextPrayerTime is null), next is tomorrow's Fajr
            if (nextPrayerTime == null) {
              final tomorrow = now.add(const Duration(days: 1));
              final tomorrowResult = prayerRepository.getPrayerTimes(
                settings: state.settings,
                coords: coords,
                dateTime: tomorrow,
              );

              tomorrowResult.fold(
                (failure) => null, // Silent or handle if critical
                (tomorrowPrayerTimes) {
                  nextPrayerTime = tomorrowPrayerTimes.fajr;
                },
              );
            }

            // Build display models for UI
            final displayModels = prayerTypes.map((prayer) {
              final time = prayerTimesService.getPrayerTime(
                prayerTimes,
                prayer,
              );
              final displayName = PrayerNameProvider.getName(
                prayer,
                _currentLocale,
              );
              final isNext = prayer == nextPrayerType;

              return PrayerDisplayModel(
                type: prayer,
                time: time,
                displayName: displayName,
                isCurrent: prayer == currentPrayerType,
                isNext: isNext,
                sunnahTimes: sunnahTimes,
              );
            }).toList();

            final currentFajrTime = prayerTimesService.getPrayerTime(
              prayerTimes,
              Prayer.fajr,
            );
            // If next prayer is tomorrow's Fajr, replace today's Fajr with tomorrow's for display
            if (nextPrayerType == Prayer.fajr &&
                nextPrayerTime != null &&
                nextPrayerTime!.isAfter(currentFajrTime)) {
              final tomorrowFajrName = PrayerNameProvider.getName(
                Prayer.fajr,
                _currentLocale,
              );

              final fajrIndex = displayModels.indexWhere(
                (p) => p.type == Prayer.fajr,
              );
              if (fajrIndex != -1) {
                displayModels[fajrIndex] = PrayerDisplayModel(
                  type: Prayer.fajr,
                  time: nextPrayerTime!,
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
              timeRemaining = nextPrayerTime!.difference(now);
              if (timeRemaining.isNegative) {
                timeRemaining = Duration.zero;
              }
            }

            emit(
              state.copyWith(
                status: PrayerTimesStatus.success,
                prayers: displayModels,
                timeRemaining: timeRemaining,
                sunnahTimes: sunnahTimes,
              ),
            );

            // Schedule next update if we have a time
            if (nextPrayerTime != null) {
              _scheduleNextUpdate(nextPrayerTime!);
            }
          },
        );
      },
    );
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
