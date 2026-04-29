import 'dart:async';
import 'package:adhan/adhan.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/networking/api_result.dart';
import 'package:sana/core/services/local_storage/storage_keys.dart';
import 'package:sana/core/services/local_storage/i_local_storage_service.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/prayer/data/models/coordinates_model.dart';
import 'package:sana/features/prayer/data/models/prayer_calculation_settings.dart';
import 'package:sana/features/prayer/data/models/prayer_times_entity.dart';
import 'package:sana/features/prayer/data/models/user_prayer_times_settings.dart';

abstract class IPrayerRepository {
  ApiResult<CoordinatesModel> getCoordinates();
  ApiResult<PrayerTimesEntity> getPrayerTimes({
    required CoordinatesModel coords,
    required UserPrayerTimesSettings settings,
    required DateTime dateTime,
  });
}

class PrayerRepoImpl implements IPrayerRepository {
  PrayerRepoImpl(this._sharedPref);
  final ILocalStorageService _sharedPref;

  static const double _defaultLat = 30.033333;
  static const double _defaultLng = 31.233334;

  @override
  ApiResult<CoordinatesModel> getCoordinates() {
    try {
      final lat = _sharedPref.getDouble(StorageKeys.latitude) ?? _defaultLat;
      final lng = _sharedPref.getDouble(StorageKeys.longitude) ?? _defaultLng;
      return ApiResult.success(CoordinatesModel(lat, lng));
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error('GetCoordinates Error', error: e, stackTrace: stack),
      );
      return const ApiResult.failure(
        Failure.location(
          message: AppStrings.locationError,
        ),
      );
    }
  }

  @override
  ApiResult<PrayerTimesEntity> getPrayerTimes({
    required CoordinatesModel coords,
    required UserPrayerTimesSettings settings,
    required DateTime dateTime,
  }) {
    try {
      final adhanCoords = Coordinates(coords.latitude, coords.longitude);
      
      final params = _mapCalculationMethod(settings.method).getParameters()
        ..madhab = _mapMadhab(settings.madhab)
        ..adjustments = _mapAdjustments(settings.adjustments);

      final prayerTimes = PrayerTimes(
        adhanCoords,
        DateComponents.from(dateTime),
        params,
      );

      final entity = PrayerTimesEntity(
        fajr: prayerTimes.fajr,
        sunrise: prayerTimes.sunrise,
        dhuhr: prayerTimes.dhuhr,
        asr: prayerTimes.asr,
        maghrib: prayerTimes.maghrib,
        isha: prayerTimes.isha,
        date: dateTime,
      );

      return ApiResult.success(entity);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error('GetPrayerTimes Error', error: e, stackTrace: stack),
      );
      return const ApiResult.failure(
        Failure.unknown(
          message: AppStrings.ourFault,
        ),
      );
    }
  }

  CalculationMethod _mapCalculationMethod(CalculationMethodEntity method) {
    return switch (method) {
      CalculationMethodEntity.muslimWorldLeague => CalculationMethod.muslim_world_league,
      CalculationMethodEntity.egyptian => CalculationMethod.egyptian,
      CalculationMethodEntity.karachi => CalculationMethod.karachi,
      CalculationMethodEntity.ummAlQura => CalculationMethod.umm_al_qura,
      CalculationMethodEntity.dubai => CalculationMethod.dubai,
      CalculationMethodEntity.moonSightingCommittee => CalculationMethod.moon_sighting_committee,
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
