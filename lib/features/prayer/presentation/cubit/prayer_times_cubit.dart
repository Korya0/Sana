import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/services/app_date/presentation/controller/app_date_cubit.dart';
import 'package:sana/core/services/app_date/presentation/controller/app_date_state.dart';
import 'package:sana/core/services/location_manager/presentation/controller/location_permission/location_cubit.dart';
import 'package:sana/features/prayer/data/constants/prayer_name_provider.dart';
import 'package:sana/features/prayer/data/models/prayer_display_model.dart';
import 'package:sana/features/prayer/data/models/prayer_state_result.dart';
import 'package:sana/features/prayer/data/models/user_prayer_times_settings.dart';
import 'package:sana/features/prayer/data/repos/prayer_repository.dart';
import 'package:sana/features/prayer/data/services/prayer_status_service.dart';
import 'package:sana/features/prayer/data/services/prayer_times_service.dart';
import 'package:sana/features/prayer/data/services/religious_events_service.dart';
import 'package:sana/features/prayer/data/services/user_settings_service.dart';
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

  final PrayerTimesService prayerTimesService;
  final IPrayerRepository prayerRepository;
  final UserSettingsService settingsService;
  final AppDateCubit appDateCubit;
  final LocationCubit locationCubit;
  final ReligiousEventsService religiousEventsService;
  final PrayerStatusService prayerStatusService;
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

    await coordsResult.when(
      failure: (failure) async {
        emit(
          PrayerTimesError(settings: state.settings, failure: failure),
        );
      },
      success: (coords) async {
        final prayerTimesResult = prayerRepository.getPrayerTimes(
          settings: state.settings,
          coords: coords,
          dateTime: baseDate,
        );

        await prayerTimesResult.when(
          failure: (failure) async {
            emit(
              PrayerTimesError(
                settings: state.settings,
                failure: failure,
              ),
            );
          },
          success: (prayerTimes) async {
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

            final displayModels = _buildDisplayModels(
              prayerTimes,
              sunnahTimes,
              prayerState,
              nextPrayerTime,
            );

            final hijriDate = appDateCubit.state.dateValue.hijri;
            final currentEvent = await religiousEventsService.getEventForDate(
              hijriDate,
            );
            final isEventToday = currentEvent?.isOccurring(hijriDate) ?? false;

            // Get status details from service using calculated ID
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
          },
        );
      },
    );
  }

  List<PrayerDisplayModel> _buildDisplayModels(
    PrayerTimes prayerTimes,
    SunnahTimes sunnahTimes,
    PrayerStateResult prayerState,
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
      final time = prayerTimes.timeForPrayer(type);
      final isNext = type == prayerState.next;

      return PrayerDisplayModel(
        type: type,
        time: (isNext && resolvedNextTime != null) ? resolvedNextTime : time!,
        displayName: PrayerNameProvider.getName(type, _currentLocale),
        isCurrent: type == prayerState.current,
        isNext: isNext,
        sunnahTimes: sunnahTimes,
      );
    }).toList();
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
