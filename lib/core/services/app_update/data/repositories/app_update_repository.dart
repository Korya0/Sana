import 'dart:async';

import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/networking/api_result.dart';
import 'package:sana/core/services/app_update/data/models/update_config_model.dart';
import 'package:sana/core/services/app_update/data/services/app_update_service.dart';
import 'package:sana/core/utils/app_logger.dart';

abstract class IAppUpdateRepository {
  Future<ApiResult<UpdateConfigModel?>> getCachedConfig();
  Future<ApiResult<UpdateConfigModel>> fetchRemoteConfig();
  Future<ApiResult<void>> cacheConfig(UpdateConfigModel config);
}

class AppUpdateRepository implements IAppUpdateRepository {
  AppUpdateRepository(this._service);
  final AppUpdateService _service;

  @override
  Future<ApiResult<UpdateConfigModel?>> getCachedConfig() async {
    try {
      final config = await _service.getCachedConfig();
      return ApiResult.success(config);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error('GetCachedConfig Error', error: e, stackTrace: stack),
      );
      return const ApiResult.failure(
        Failure.cache(
          message: AppStrings.ourFault,
        ),
      );
    }
  }

  @override
  Future<ApiResult<UpdateConfigModel>> fetchRemoteConfig() async {
    try {
      final config = await _service.fetchRemoteConfig();
      if (config == null) {
        return const ApiResult.failure(
          Failure.server(message: AppStrings.ourFault),
        );
      }
      return ApiResult.success(config);
    } on Exception catch (e) {
      unawaited(
        Future.microtask(() => AppLogger.warn('FetchRemoteConfig Error: $e')),
      );
      return const ApiResult.failure(
        Failure.server(
          message: AppStrings.ourFault,
        ),
      );
    }
  }

  @override
  Future<ApiResult<void>> cacheConfig(UpdateConfigModel config) async {
    try {
      await _service.cacheConfig(config);
      return const ApiResult.success(null);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error('CacheConfig Error', error: e, stackTrace: stack),
      );
      return const ApiResult.failure(
        Failure.cache(
          message: AppStrings.ourFault,
        ),
      );
    }
  }
}
