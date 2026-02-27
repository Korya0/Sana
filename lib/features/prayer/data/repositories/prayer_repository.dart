import 'package:adhan/adhan.dart';
import 'package:dartz/dartz.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/services/sharedpref/pref_keys.dart';
import 'package:sana/core/services/sharedpref/shared_pref.dart';
import 'package:sana/features/prayer/data/models/user_prayer_times_settings.dart';
import 'package:sana/features/prayer/data/services/prayer_times_service.dart';

abstract class IPrayerRepository {
  Either<Failure, Coordinates> getCoordinates();
  Either<Failure, PrayerTimes> getPrayerTimes({
    required Coordinates coords,
    required UserPrayerTimesSettings settings,
    required DateTime dateTime,
  });
}

class PrayerRepository implements IPrayerRepository {
  PrayerRepository(this._service, this._sharedPref);
  final PrayerTimesService _service;
  final SharedPref _sharedPref;

  @override
  Either<Failure, Coordinates> getCoordinates() {
    try {
      final lat = _sharedPref.getDouble(PrefKeys.latitude) ?? 30.033333;
      final lng = _sharedPref.getDouble(PrefKeys.longitude) ?? 31.233334;
      return Right(Coordinates(lat, lng));
    } catch (e) {
      return const Left(
        LocationFailure(
          message: AppStrings.locationError,
        ),
      );
    }
  }

  @override
  Either<Failure, PrayerTimes> getPrayerTimes({
    required Coordinates coords,
    required UserPrayerTimesSettings settings,
    required DateTime dateTime,
  }) {
    try {
      final prayerTimes = _service.calculatePrayerTimes(
        coords: coords,
        settings: settings,
        dateTime: dateTime,
      );
      return Right(prayerTimes);
    } catch (e) {
      return const Left(
        UnknownFailure(
          message: AppStrings.unknownError,
        ),
      );
    }
  }
}
