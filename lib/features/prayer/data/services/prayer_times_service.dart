import 'package:adhan/adhan.dart';
import 'package:sana/features/prayer/data/models/prayer_state_result.dart';
import 'package:sana/features/prayer/data/services/prayer_state_service.dart';
import 'package:sana/features/prayer/data/services/user_settings_service.dart';

/// Core service for fetching [PrayerTimes] and [SunnahTimes].
/// Now delegates the state calculation to [PrayerStateService].
class PrayerTimesService {
  PrayerTimesService({
    required UserSettingsService settingsService,
    required PrayerStateService stateService,
  }) : _settingsService = settingsService,
       _stateService = stateService;

  final UserSettingsService _settingsService;
  final PrayerStateService _stateService;

  /// Fetches prayer times based on stored user settings.
  Future<PrayerTimes> getTimes(Coordinates coords, DateTime date) async {
    final params = await _settingsService.getCalculationParameters();
    final dateComponents = DateComponents.from(date);

    return PrayerTimes(coords, dateComponents, params);
  }

  /// Calculates the prayer state result using the state service.
  PrayerStateResult calculateState(PrayerTimes prayerTimes, DateTime date) {
    return _stateService.calculateState(
      prayerTimes: prayerTimes,
      date: date,
    );
  }

  /// Calculates sunnah times for a given set of prayer times.
  SunnahTimes calculateSunnah(PrayerTimes prayerTimes) {
    return SunnahTimes(prayerTimes);
  }

  /// Helper to get current calculation parameters.
  Future<CalculationParameters> getParams() =>
      _settingsService.getCalculationParameters();

  /// Resolves the actual [DateTime] for the next prayer using the state service.
  Future<DateTime?> resolveNextTime({
    required PrayerStateResult state,
    required Coordinates coords,
    required DateTime baseDate,
    required DateTime now,
  }) async {
    final params = await getParams();
    return _stateService.resolveNextTime(
      state: state,
      coords: coords,
      params: params,
      baseDate: baseDate,
      now: now,
    );
  }
}
