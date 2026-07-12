import 'package:sana/core/constants/app_constants.dart';
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/app_date/data/models/app_date_model.dart';
import 'package:sana/features/prayer/data/services/prayer_status_service.dart';
import 'package:sana/features/prayer/data/services/prayer_times_service.dart';
import 'package:sana/features/prayer/data/services/religious_events_service.dart';
import 'package:sana/features/prayer/data/services/user_settings_service.dart';
import 'package:sana/features/prayer/domain/entities/user_prayer_times_settings_entity.dart';
import 'package:sana/features/prayer/domain/repos/i_prayer_repository.dart';
import 'package:sana/features/prayer/domain/use_cases/religious_event_use_cases.dart';
import 'package:sana/features/prayer/presentation/models/prayer_display_model.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/features/prayer/presentation/cubit/prayer_times_state.dart';

/// كيوبيت مواقيت الصلاة.
///
/// **المسؤوليات**:
/// - تحميل الإعدادات.
/// - حساب مواقيت الصلاة بناءً على التاريخ والحالة الهجرية الممرَّرة.
/// - جدولة المؤقت للتحديث التلقائي عند دخول وقت الصلاة التالية.
///
/// **ما لا يفعله هذا الكيوبيت**:
/// - لا يُراقب دورة حياة التطبيق (مسؤولية الـ View).
/// - لا يستمع لـ LocationCubit أو AppDateCubit مباشرة (التنسيق يتم في الـ View).
class PrayerTimesCubit extends Cubit<PrayerTimesState> {
  PrayerTimesCubit({
    required this.prayerTimesService,
    required this.prayerRepository,
    required this.settingsService,
    required this.religiousEventsService,
    required this.prayerStatusService,
  }) : super(
         PrayerTimesInitial(
           settings: UserPrayerTimesSettings.defaultSettings(),
         ),
       );

  final IPrayerTimesService prayerTimesService;
  final IPrayerRepository prayerRepository;
  final IUserSettingsService settingsService;
  final IReligiousEventsService religiousEventsService;
  final IPrayerStatusService prayerStatusService;

  Timer? _timer;

  String _currentLocale = 'ar';

  /// يُهيّئ الخدمات ويُحمّل الإعدادات.
  /// يُستدعى من الـ View بعد بناء الـ Widget tree.
  Future<void> init() async {
    await religiousEventsService.init();
    await prayerStatusService.init();
    await loadSettings();
  }

  // ignore: use_setters_to_change_properties, method syntax is preferred over setter for consistency with other initialization methods in this cubit.
  void setLocale(String locale) {
    _currentLocale = locale;
  }

  /// يُحدّث مواقيت الصلاة — يُستدعى من الـ View عند:
  /// - العودة للتطبيق من الخلفية.
  /// - تغيير الموقع.
  /// - تغيير التاريخ.
  void refresh({required AppDateModel appDate}) {
    unawaited(_calculatePrayerTimes(appDate));
  }

  Future<void> loadSettings() async {
    final settings = await settingsService.loadSettings();
    emit(PrayerTimesInitial(settings: settings));
  }

  Future<void> updateSettings(UserPrayerTimesSettings settings) async {
    await settingsService.saveSettings(settings);
    emit(state.copyWith(settings: settings));
  }

  Future<void> _calculatePrayerTimes(AppDateModel appDate) async {
    if (isClosed) return;
    final now = DateTime.now();
    final baseDate = appDate.gregorian;
    final hijriDate = appDate.hijri;

    final prayerTimesResult = prayerRepository.getPrayerTimes(
      settings: state.settings,
      dateTime: baseDate,
    );

    switch (prayerTimesResult) {
      case FailureResult(:final failure):
        if (isClosed) return;
        emit(PrayerTimesError(settings: state.settings, failure: failure));
      case Success(data: final prayerTimes):
        final sunnahTimes = prayerTimesService.calculateSunnah(prayerTimes);
        final prayerState = prayerTimesService.calculateState(prayerTimes, now);

        final nextPrayerTime = await prayerTimesService.resolveNextTime(
          state: prayerState,
          baseDate: baseDate,
          now: now,
        );

        if (isClosed) return;

        final displayModels = PrayerDisplayModel.buildList(
          prayerTimes: prayerTimes,
          sunnahTimes: sunnahTimes,
          prayerState: prayerState,
          resolvedNextTime: nextPrayerTime,
          locale: _currentLocale,
        );

        final currentEvent = await religiousEventsService.getEventForDate(
          hijriDate,
        );

        const isOccurring = IsReligiousEventOccurringUseCase();
        final isEventToday =
            currentEvent != null && isOccurring(currentEvent, hijriDate);

        final currentStatus = prayerStatusService.getStatusById(
          prayerState.statusId,
        );

        if (isClosed) return;
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
          _scheduleNextUpdate(nextPrayerTime, appDate);
        }
    }
  }

  void _scheduleNextUpdate(DateTime nextTime, AppDateModel appDate) {
    _timer?.cancel();
    final now = DateTime.now();
    final duration = nextTime.difference(now);
    final scheduleDuration = duration.isNegative
        ? const Duration(seconds: 1)
        : duration + AppConstants.hiveInitTimeout2s;

    _timer = Timer(scheduleDuration, () {
      if (isClosed) return; // ✅ حماية من الكراش بعد إغلاق الكيوبيت
      unawaited(_calculatePrayerTimes(appDate));
    });
  }

  @override
  Future<void> close() async {
    _timer?.cancel();
    return super.close();
  }
}
