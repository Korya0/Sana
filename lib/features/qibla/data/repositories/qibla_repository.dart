import 'package:dartz/dartz.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/services/sharedpref/pref_keys.dart';
import 'package:sana/core/services/sharedpref/shared_pref.dart';
import 'package:sana/features/qibla/data/qibla_constants.dart';
import 'package:sana/features/qibla/data/services/qibla_service.dart';

class QiblaRepository {
  QiblaRepository({required SharedPref sharedPref}) : _sharedPref = sharedPref;
  final SharedPref _sharedPref;

  Either<Failure, Map<String, double>> getUserLocation() {
    try {
      final lat = _sharedPref.getDouble(PrefKeys.latitude);
      final lng = _sharedPref.getDouble(PrefKeys.longitude);

      if (lat == null || lng == null) {
        return const Left(LocationFailure(message: AppStrings.locationError));
      }

      return Right({'lat': lat, 'lng': lng});
    } catch (e) {
      return Left(
        LocationFailure(
          message: AppStrings.locationError,
          technicalMessage: e.toString(),
        ),
      );
    }
  }

  Either<Failure, double> calculateQiblaDirection(double lat, double lng) {
    try {
      final direction = QiblaService.calculateQiblaDirection(lat, lng);
      return Right(direction);
    } catch (e) {
      return Left(
        SensorFailure(
          message: AppStrings.sensorError,
          technicalMessage: e.toString(),
        ),
      );
    }
  }

  Either<Failure, double> calculateDistanceToKaaba(double lat, double lng) {
    try {
      final distance = QiblaService.calculateDistance(
        lat,
        lng,
        QiblaConstants.kaabaLatitude,
        QiblaConstants.kaabaLongitude,
      );
      return Right(distance);
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
