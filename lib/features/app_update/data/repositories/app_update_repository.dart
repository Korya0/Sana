import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/app_update/data/models/update_config_model.dart';
import 'package:sana/features/app_update/data/services/app_update_service.dart';

abstract class IAppUpdateRepository {
  Future<Either<Failure, UpdateConfigModel?>> getCachedConfig();
  Future<Either<Failure, UpdateConfigModel>> fetchRemoteConfig();
  Future<Either<Failure, void>> cacheConfig(UpdateConfigModel config);
}

class AppUpdateRepository implements IAppUpdateRepository {
  AppUpdateRepository(this._service);
  final AppUpdateService _service;

  @override
  Future<Either<Failure, UpdateConfigModel?>> getCachedConfig() async {
    try {
      final config = await _service.getCachedConfig();
      return Right(config);
    } catch (e, stack) {
      unawaited(
        AppLogger.error('GetCachedConfig Error', error: e, stackTrace: stack),
      );
      return const Left(
        CacheFailure(
          message: AppStrings.ourFault,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, UpdateConfigModel>> fetchRemoteConfig() async {
    try {
      final config = await _service.fetchRemoteConfig();
      if (config == null) {
        return const Left(ServerFailure(message: AppStrings.ourFault));
      }
      return Right(config);
    } catch (e, stack) {
      unawaited(
        AppLogger.error('FetchRemoteConfig Error', error: e, stackTrace: stack),
      );
      return const Left(
        ServerFailure(
          message: AppStrings.ourFault,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> cacheConfig(UpdateConfigModel config) async {
    try {
      await _service.cacheConfig(config);
      return const Right(null);
    } catch (e, stack) {
      unawaited(
        AppLogger.error('CacheConfig Error', error: e, stackTrace: stack),
      );
      return const Left(
        CacheFailure(
          message: AppStrings.ourFault,
        ),
      );
    }
  }
}
