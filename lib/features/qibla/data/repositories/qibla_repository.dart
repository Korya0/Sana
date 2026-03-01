import 'package:dartz/dartz.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/features/qibla/data/datasources/qibla_local_data_source.dart';
import 'package:sana/features/qibla/data/qibla_constants.dart';
import 'package:sana/features/qibla/data/services/qibla_service.dart';

abstract class IQiblaRepository {
  Either<Failure, Map<String, double>> getUserLocation();
  Either<Failure, double> calculateQiblaDirection(double lat, double lng);
  Either<Failure, double> calculateDistanceToKaaba(double lat, double lng);
}

class QiblaRepository implements IQiblaRepository {
  QiblaRepository({
    required QiblaLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource;

  final QiblaLocalDataSource _localDataSource;

  @override
  Either<Failure, Map<String, double>> getUserLocation() {
    try {
      final lat = _localDataSource.getLatitude();
      final lng = _localDataSource.getLongitude();

      if (lat == null || lng == null) {
        return const Left(LocationFailure(message: AppStrings.locationError));
      }

      return Right({'lat': lat, 'lng': lng});
    } catch (e) {
      return const Left(
        LocationFailure(
          message: AppStrings.locationError,
        ),
      );
    }
  }

  @override
  Either<Failure, double> calculateQiblaDirection(double lat, double lng) {
    try {
      final direction = QiblaService.calculateQiblaDirection(lat, lng);
      return Right(direction);
    } catch (e) {
      return const Left(
        SensorFailure(
          message: AppStrings.sensorError,
        ),
      );
    }
  }

  @override
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
      return const Left(
        UnknownFailure(
          message: AppStrings.ourFault,
        ),
      );
    }
  }
}
