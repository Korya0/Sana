import 'package:sana/features/prayer/data/models/coordinates_model.dart';
import 'package:sana/features/prayer/data/models/prayer_times_entity.dart';
import 'package:sana/features/prayer/data/models/prayer_state_result.dart';
import 'package:sana/features/prayer/data/models/sunnah_times_entity.dart';
import 'package:sana/features/prayer/data/services/prayer_state_service.dart';
import 'package:sana/features/prayer/data/services/user_settings_service.dart';

abstract class IPrayerTimesService {
  PrayerStateResult calculateState(
    PrayerTimesEntity prayerTimes,
    DateTime date,
  );
  SunnahTimesEntity calculateSunnah(PrayerTimesEntity prayerTimes);
  Future<DateTime?> resolveNextTime({
    required PrayerStateResult state,
    required CoordinatesModel coords,
    required DateTime baseDate,
    required DateTime now,
  });
}

class PrayerTimesServiceImpl implements IPrayerTimesService {
  PrayerTimesServiceImpl({
    required IUserSettingsService settingsService,
    required IPrayerStateService stateService,
  }) : _settingsService = settingsService,
       _stateService = stateService;

  final IUserSettingsService _settingsService;
  final IPrayerStateService _stateService;

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
    required CoordinatesModel coords,
    required DateTime baseDate,
    required DateTime now,
  }) async {
    final settings = await _settingsService.loadSettings();
    return _stateService.resolveNextTime(
      state: state,
      coords: coords,
      settings: settings,
      baseDate: baseDate,
      now: now,
    );
  }
}
