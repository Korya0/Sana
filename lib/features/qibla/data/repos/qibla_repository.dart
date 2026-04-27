import 'dart:async';

import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/networking/api_result.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/qibla/data/datasources/qibla_local_data_source.dart';
import 'package:sana/features/qibla/data/models/qibla_models.dart';
import 'package:sana/features/qibla/data/qibla_constants.dart';
import 'package:sana/features/qibla/data/services/qibla_service.dart';

abstract interface class IQiblaRepository {
  ApiResult<QiblaLocationModel> getUserLocation();

  ApiResult<double> calculateQiblaDirection(double lat, double lng);

  ApiResult<double> calculateDistanceToKaaba(double lat, double lng);
}

class QiblaRepoImpl implements IQiblaRepository {
  QiblaRepoImpl({
    required IQiblaLocalDataSource localDataSource,
    required IQiblaService qiblaService,
  })  : _localDataSource = localDataSource,
        _qiblaService = qiblaService;

  final IQiblaLocalDataSource _localDataSource;
  final IQiblaService _qiblaService;

  @override
  ApiResult<QiblaLocationModel> getUserLocation() {
    try {
      final lat = _localDataSource.getLatitude();
      final lng = _localDataSource.getLongitude();

      if (lat == null || lng == null) {
        return const ApiResult.failure(
          Failure.location(message: AppStrings.locationError),
        );
      }

      return ApiResult.success(
        QiblaLocationModel(latitude: lat, longitude: lng),
      );
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
      final direction = _qiblaService.calculateQiblaDirection(lat, lng);
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
      final distance = _qiblaService.calculateDistance(
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
