import 'package:dartz/dartz.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
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
    } catch (e) {
      return Left(
        CacheFailure(
          message: AppStrings.cacheError,
          technicalMessage: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, UpdateConfigModel>> fetchRemoteConfig() async {
    try {
      final config = await _service.fetchRemoteConfig();
      if (config == null) {
        return const Left(ServerFailure(message: AppStrings.serverError));
      }
      return Right(config);
    } catch (e) {
      return Left(
        ServerFailure(
          message: AppStrings.serverError,
          technicalMessage: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> cacheConfig(UpdateConfigModel config) async {
    try {
      await _service.cacheConfig(config);
      return const Right(null);
    } catch (e) {
      return Left(
        CacheFailure(
          message: AppStrings.cacheError,
          technicalMessage: e.toString(),
        ),
      );
    }
  }
}
