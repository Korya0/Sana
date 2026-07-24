import 'package:sana/features/prayer/domain/entities/prayer_times_entity.dart';
import 'package:sana/features/prayer/domain/entities/prayer_state_result.dart';
import 'package:sana/features/prayer/domain/entities/sunnah_times_entity.dart';
import 'package:sana/features/prayer/data/services/prayer_state_service.dart';
import 'package:sana/features/prayer/data/services/user_settings_service.dart';

abstract interface class PrayerTimesService {
  PrayerStateResult calculateState(
    PrayerTimesEntity prayerTimes,
    DateTime date,
  );
  SunnahTimesEntity calculateSunnah(PrayerTimesEntity prayerTimes);
  Future<DateTime?> resolveNextTime({
    required PrayerStateResult state,
    required DateTime baseDate,
    required DateTime now,
    Object? coords,
  });
}

class PrayerTimesServiceImpl implements PrayerTimesService {
  PrayerTimesServiceImpl({
    required UserSettingsService settingsService,
    required PrayerStateService stateService,
  }) : _settingsService = settingsService,
       _stateService = stateService;

  final UserSettingsService _settingsService;
  final PrayerStateService _stateService;

  @override
  PrayerStateResult calculateState(
    PrayerTimesEntity prayerTimes,
    DateTime date,
  ) {
    return _stateService.calculateState(
      prayerTimes: prayerTimes,
      date: date,
    );
  }

  @override
  SunnahTimesEntity calculateSunnah(PrayerTimesEntity prayerTimes) {
    return _stateService.calculateSunnah(prayerTimes);
  }

  @override
  Future<DateTime?> resolveNextTime({
    required PrayerStateResult state,
    required DateTime baseDate,
    required DateTime now,
    Object? coords,
  }) async {
    final settings = await _settingsService.loadSettings();
    // coords غير مستخدم هنا — الـ Repo يجلبهم داخلياً
    return _stateService.resolveNextTime(
      state: state,
      settings: settings,
      baseDate: baseDate,
      now: now,
    );
  }
}
