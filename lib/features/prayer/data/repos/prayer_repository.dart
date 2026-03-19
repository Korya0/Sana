import 'dart:async';
import 'package:adhan/adhan.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/networking/api_result.dart';
import 'package:sana/core/services/local_storage/storage_keys.dart';
import 'package:sana/core/services/local_storage/local_storage_service.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/prayer/data/models/user_prayer_times_settings.dart';

abstract class IPrayerRepository {
  ApiResult<Coordinates> getCoordinates();
  ApiResult<PrayerTimes> getPrayerTimes({
    required Coordinates coords,
    required UserPrayerTimesSettings settings,
    required DateTime dateTime,
  });
}

class PrayerRepoImpl implements IPrayerRepository {
  PrayerRepoImpl(this._sharedPref);
  final ILocalStorageService _sharedPref;

  @override
  ApiResult<Coordinates> getCoordinates() {
    try {
      final lat = _sharedPref.getDouble(StorageKeys.latitude) ?? 30.033333;
      final lng = _sharedPref.getDouble(StorageKeys.longitude) ?? 31.233334;
      return ApiResult.success(Coordinates(lat, lng));
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
  ApiResult<PrayerTimes> getPrayerTimes({
    required Coordinates coords,
    required UserPrayerTimesSettings settings,
    required DateTime dateTime,
  }) {
    try {
      final params = settings.method.getParameters()
        ..madhab = settings.madhab
        ..adjustments = settings.adjustments;

      final prayerTimes = PrayerTimes(
        coords,
        DateComponents.from(dateTime),
        params,
      );
      return ApiResult.success(prayerTimes);
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
}
