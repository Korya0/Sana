import 'dart:async';

import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/error/error.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/qibla/constants/qibla_data_constants.dart';
import 'package:sana/features/qibla/data/datasources/qibla_local_data_source.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entities.dart';
import 'package:sana/features/qibla/domain/repositories/qibla_repository.dart';
import 'package:sana/features/qibla/domain/services/qibla_service.dart';

class QiblaRepoImpl implements IQiblaRepository {
  QiblaRepoImpl({
    required IQiblaLocalDataSource localDataSource,
    required IQiblaService qiblaService,
  }) : _localDataSource = localDataSource,
       _qiblaService = qiblaService;

  final IQiblaLocalDataSource _localDataSource;
  final IQiblaService _qiblaService;

  @override
  Result<QiblaLocationEntity> getUserLocation() {
    try {
      final lat = _localDataSource.getLatitude();
      final lng = _localDataSource.getLongitude();

      if (lat == null || lng == null) {
        return const Result.failure(
          LocationFailure(message: AppStrings.locationError),
        );
      }

      return Result.success(
        QiblaLocationEntity(latitude: lat, longitude: lng),
      );
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.warn('GetUserLocation Error', error: e, stackTrace: stack),
      );
      return const Result.failure(
        LocationFailure(
          message: AppStrings.locationError,
        ),
      );
    }
  }

  @override
  Result<double> calculateQiblaDirection(double lat, double lng) {
    try {
      final direction = _qiblaService.calculateQiblaDirection(lat, lng);
      return Result.success(direction);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.localError('CalculateQibla Error', error: e, stackTrace: stack),
      );
      return const Result.failure(
        SensorFailure(
          message: AppStrings.sensorError,
        ),
      );
    }
  }

  @override
  Result<double> calculateDistanceToKaaba(double lat, double lng) {
    try {
      final distance = _qiblaService.calculateDistance(
        lat,
        lng,
        QiblaDataConstants.kaabaLatitude,
        QiblaDataConstants.kaabaLongitude,
      );
      return Result.success(distance);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.localError('CalculateDistance Error', error: e, stackTrace: stack),
      );
      return const Result.failure(
        UnknownFailure(
          message: AppStrings.ourFault,
        ),
      );
    }
  }
}
