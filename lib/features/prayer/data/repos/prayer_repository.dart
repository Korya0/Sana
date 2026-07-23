import 'dart:async';
import 'package:adhan/adhan.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/error/error.dart';
import 'package:sana/core/network/result.dart';
import 'package:sana/core/services/local_storage/storage_keys.dart';
import 'package:sana/core/services/local_storage/i_local_storage_service.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/prayer/domain/entities/prayer_calculation_settings_entity.dart';
import 'package:sana/features/prayer/domain/entities/prayer_times_entity.dart';
import 'package:sana/features/prayer/domain/entities/user_prayer_times_settings_entity.dart';
import 'package:sana/features/prayer/domain/repos/i_prayer_repository.dart';

/// تطبيق مستودع بيانات الصلاة.
/// يجلب الإحداثيات داخلياً من التخزين المحلي ويحسب المواقيت
/// دون أن يُحمّل الكيوبيت أي اعتمادية على تفاصيل الموقع.
class PrayerRepoImpl implements IPrayerRepository {
  PrayerRepoImpl(this._sharedPref);

  final ILocalStorageService _sharedPref;

  // الإحداثيات الافتراضية (القاهرة) تُستخدم فقط كاحتياط عند غياب الموقع المحفوظ
  static const double _defaultLat = 30.033333;
  static const double _defaultLng = 31.233334;

  @override
  Result<PrayerTimesEntity> getPrayerTimes({
    required UserPrayerTimesSettings settings,
    required DateTime dateTime,
  }) {
    try {
      // جلب الإحداثيات داخلياً — الكيوبيت لا يعلم بهذه التفاصيل
      final lat = _sharedPref.getDouble(StorageKeys.latitude) ?? _defaultLat;
      final lng = _sharedPref.getDouble(StorageKeys.longitude) ?? _defaultLng;
      final adhanCoords = Coordinates(lat, lng);

      final params = _mapCalculationMethod(settings.method).getParameters()
        ..madhab = _mapMadhab(settings.madhab)
        ..adjustments = _mapAdjustments(settings.adjustments);

      final prayerTimes = PrayerTimes(
        adhanCoords,
        DateComponents.from(dateTime),
        params,
      );

      return Result.success(
        PrayerTimesEntity(
          fajr: prayerTimes.fajr,
          sunrise: prayerTimes.sunrise,
          dhuhr: prayerTimes.dhuhr,
          asr: prayerTimes.asr,
          maghrib: prayerTimes.maghrib,
          isha: prayerTimes.isha,
          date: dateTime,
        ),
      );
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.localError(
          'GetPrayerTimes Error',
          error: e,
          stackTrace: stack,
        ),
      );
      return const Result.failure(UnknownFailure(message: AppStrings.ourFault));
    }
  }

  CalculationMethod _mapCalculationMethod(CalculationMethodEntity method) {
    return switch (method) {
      CalculationMethodEntity.muslimWorldLeague =>
        CalculationMethod.muslim_world_league,
      CalculationMethodEntity.egyptian => CalculationMethod.egyptian,
      CalculationMethodEntity.karachi => CalculationMethod.karachi,
      CalculationMethodEntity.ummAlQura => CalculationMethod.umm_al_qura,
      CalculationMethodEntity.dubai => CalculationMethod.dubai,
      CalculationMethodEntity.moonSightingCommittee =>
        CalculationMethod.moon_sighting_committee,
      CalculationMethodEntity.northAmerica => CalculationMethod.north_america,
      CalculationMethodEntity.kuwait => CalculationMethod.kuwait,
      CalculationMethodEntity.qatar => CalculationMethod.qatar,
      CalculationMethodEntity.singapore => CalculationMethod.singapore,
      CalculationMethodEntity.tehran => CalculationMethod.tehran,
      CalculationMethodEntity.turkey => CalculationMethod.turkey,
      CalculationMethodEntity.other => CalculationMethod.other,
    };
  }

  Madhab _mapMadhab(MadhabEntity madhab) {
    return switch (madhab) {
      MadhabEntity.shafi => Madhab.shafi,
      MadhabEntity.hanafi => Madhab.hanafi,
    };
  }

  PrayerAdjustments _mapAdjustments(PrayerAdjustmentsEntity adjustments) {
    return PrayerAdjustments(
      fajr: adjustments.fajr,
      sunrise: adjustments.sunrise,
      dhuhr: adjustments.dhuhr,
      asr: adjustments.asr,
      maghrib: adjustments.maghrib,
      isha: adjustments.isha,
    );
  }
}
