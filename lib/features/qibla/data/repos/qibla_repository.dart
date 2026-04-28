import 'dart:async';

import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/networking/api_result.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/qibla/data/datasources/qibla_local_data_source.dart';
import 'package:sana/features/qibla/data/constants/qibla_data_constants.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entities.dart';
import 'package:sana/features/qibla/domain/repositories/qibla_repository.dart';
import 'package:sana/features/qibla/domain/services/qibla_service.dart';

class QiblaRepoImpl implements IQiblaRepository {
  QiblaRepoImpl({
    required IQiblaLocalDataSource localDataSource,
    required IQiblaService qiblaService,
  })  : _localDataSource = localDataSource,
        _qiblaService = qiblaService;

  final IQiblaLocalDataSource _localDataSource;
  final IQiblaService _qiblaService;

  @override
  ApiResult<QiblaLocationEntity> getUserLocation() {
    try {
      final lat = _localDataSource.getLatitude();
      final lng = _localDataSource.getLongitude();

      if (lat == null || lng == null) {
        return const ApiResult.failure(
          Failure.location(message: AppStrings.locationError),
        );
      }

      return ApiResult.success(
        QiblaLocationEntity(latitude: lat, longitude: lng),
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
        QiblaDataConstants.kaabaLatitude,
        QiblaDataConstants.kaabaLongitude,
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
