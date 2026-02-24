import 'package:adhan/adhan.dart';
import 'package:dartz/dartz.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
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
  PrayerRepository(this._service);
  final PrayerTimesService _service;

  @override
  Either<Failure, Coordinates> getCoordinates() {
    try {
      final coords = _service.getCoordinates();
      return Right(coords);
    } catch (e) {
      return Left(
        LocationFailure(
          message: AppStrings.locationError,
          technicalMessage: e.toString(),
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
      return Left(
        UnknownFailure(
          message: AppStrings.unknownError,
          technicalMessage: e.toString(),
        ),
      );
    }
  }
}
