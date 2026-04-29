import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/services/app_date/presentation/cubit/app_date_cubit.dart';
import 'package:sana/core/services/app_date/presentation/cubit/app_date_state.dart';
import 'package:sana/core/services/location_manager/presentation/cubit/location_permission/location_cubit.dart';
import 'package:sana/core/services/location_manager/presentation/cubit/location_permission/location_state.dart';
import 'package:sana/features/prayer/data/models/prayer_display_model.dart';
import 'package:sana/features/prayer/data/models/user_prayer_times_settings.dart';
import 'package:sana/features/prayer/data/repos/prayer_repository.dart';
import 'package:sana/features/prayer/data/services/prayer_status_service.dart';
import 'package:sana/features/prayer/data/services/prayer_times_service.dart';
import 'package:sana/features/prayer/data/services/religious_events_service.dart';
import 'package:sana/features/prayer/data/services/user_settings_service.dart';
import 'package:sana/core/networking/api_result.dart';
import 'package:sana/features/prayer/presentation/cubit/prayer_times_state.dart';

class PrayerTimesCubit extends Cubit<PrayerTimesState>
    with WidgetsBindingObserver {
  PrayerTimesCubit({
    required this.prayerTimesService,
    required this.prayerRepository,
    required this.settingsService,
    required this.appDateCubit,
    required this.locationCubit,
    required this.religiousEventsService,
    required this.prayerStatusService,
  }) : super(
         PrayerTimesInitial(
           settings: UserPrayerTimesSettings.defaultSettings(),
         ),
       ) {
    WidgetsBinding.instance.addObserver(this);
    _setupListeners();
    _init();
  }

  final IPrayerTimesService prayerTimesService;
  final IPrayerRepository prayerRepository;
  final IUserSettingsService settingsService;
  final AppDateCubit appDateCubit;
  final LocationCubit locationCubit;
  final IReligiousEventsService religiousEventsService;
  final IPrayerStatusService prayerStatusService;
  
  Timer? _timer;
  StreamSubscription<LocationState>? _locationSubscription;
  StreamSubscription<AppDateState>? _dateSubscription;

  String _currentLocale = 'ar';

  void _init() {
    unawaited(_initializeServices());
  }

  Future<void> _initializeServices() async {
    await religiousEventsService.init();
    await prayerStatusService.init();
    await loadSettings();
  }

  void _setupListeners() {
    _locationSubscription = locationCubit.stream.listen((locationState) {
      if (locationState is LocationSuccess) {
        refresh();
      }
    });

    _dateSubscription = appDateCubit.stream.listen((_) {
      refresh();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      refresh();
    }
  }

  void setLocale(String locale) {
    _currentLocale = locale;
    refresh();
  }

  void refresh() {
    unawaited(_calculatePrayerTimes());
  }

  Future<void> loadSettings() async {
    final settings = await settingsService.loadSettings();
    emit(PrayerTimesInitial(settings: settings));
    unawaited(Future.microtask(_calculatePrayerTimes));
  }

  Future<void> updateSettings(UserPrayerTimesSettings settings) async {
    await settingsService.saveSettings(settings);
    emit(state.copyWith(settings: settings));
    refresh();
  }

  Future<void> _calculatePrayerTimes() async {
    final now = DateTime.now();
    final baseDate = appDateCubit.state.dateValue.gregorian;
    final coordsResult = prayerRepository.getCoordinates();

    switch (coordsResult) {
      case ApiFailure(:final failure):
        emit(PrayerTimesError(settings: state.settings, failure: failure));
      case Success(data: final coords):
        final prayerTimesResult = prayerRepository.getPrayerTimes(
          settings: state.settings,
          coords: coords,
          dateTime: baseDate,
        );

        switch (prayerTimesResult) {
          case ApiFailure(:final failure):
            emit(
              PrayerTimesError(
                settings: state.settings,
                failure: failure,
              ),
            );
          case Success(data: final prayerTimes):
            final sunnahTimes = prayerTimesService.calculateSunnah(prayerTimes);
            final prayerState = prayerTimesService.calculateState(
              prayerTimes,
              now,
            );

            final nextPrayerTime = await prayerTimesService.resolveNextTime(
              state: prayerState,
              coords: coords,
              baseDate: baseDate,
              now: now,
            );

            final displayModels = PrayerDisplayModel.buildList(
              prayerTimes: prayerTimes,
              sunnahTimes: sunnahTimes,
              prayerState: prayerState,
              resolvedNextTime: nextPrayerTime,
              locale: _currentLocale,
            );

            final hijriDate = appDateCubit.state.dateValue.hijri;
            final currentEvent = await religiousEventsService.getEventForDate(
              hijriDate,
            );
            final isEventToday = currentEvent?.isOccurring(hijriDate) ?? false;

            final currentStatus = prayerStatusService.getStatusById(
              prayerState.statusId,
            );

            emit(
              PrayerTimesLoaded(
                settings: state.settings,
                prayers: displayModels,
                timeRemaining: nextPrayerTime?.difference(now) ?? Duration.zero,
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
        }
    }
  }

  void _scheduleNextUpdate(DateTime nextTime) {
    _timer?.cancel();
    final now = DateTime.now();
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
