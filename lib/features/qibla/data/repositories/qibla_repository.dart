import 'dart:async';

import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/networking/api_result.dart';
import 'package:sana/core/services/location_manager/data/constants/location_api_constants.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/qibla/data/datasources/qibla_local_data_source.dart';
import 'package:sana/features/qibla/data/qibla_constants.dart';
import 'package:sana/features/qibla/data/services/qibla_service.dart';

abstract class IQiblaRepository {
  ApiResult<Map<String, double>> getUserLocation();
  ApiResult<double> calculateQiblaDirection(double lat, double lng);
  ApiResult<double> calculateDistanceToKaaba(double lat, double lng);
}

class QiblaRepository implements IQiblaRepository {
  QiblaRepository({
    required QiblaLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource;

  final QiblaLocalDataSource _localDataSource;

  @override
  ApiResult<Map<String, double>> getUserLocation() {
    try {
      final lat = _localDataSource.getLatitude();
      final lng = _localDataSource.getLongitude();

      if (lat == null || lng == null) {
        return const ApiResult.failure(
          Failure.location(message: AppStrings.locationError),
        );
      }

      return ApiResult.success({
        LocationApiConstants.keyLatitude: lat,
        LocationApiConstants.keyLongitude: lng,
      });
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error('GetUserLocation Error', error: e, stackTrace: stack),
      );
      return const ApiResult.failure(
        Failure.location(
          message: AppStrings.locationError,
        ),
      );
    }
  }

  @override
  ApiResult<double> calculateQiblaDirection(double lat, double lng) {
    try {
      final direction = QiblaService.calculateQiblaDirection(lat, lng);
      return ApiResult.success(direction);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error('CalculateQibla Error', error: e, stackTrace: stack),
      );
      return const ApiResult.failure(
        Failure.sensor(
          message: AppStrings.sensorError,
        ),
      );
    }
  }

  @override
  ApiResult<double> calculateDistanceToKaaba(double lat, double lng) {
    try {
      final distance = QiblaService.calculateDistance(
        lat,
        lng,
        QiblaConstants.kaabaLatitude,
        QiblaConstants.kaabaLongitude,
      );
      return ApiResult.success(distance);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error('CalculateDistance Error', error: e, stackTrace: stack),
      );
      return const ApiResult.failure(
        Failure.unknown(
          message: AppStrings.ourFault,
        ),
      );
    }
  }
}
