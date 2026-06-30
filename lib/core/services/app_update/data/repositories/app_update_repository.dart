import 'dart:async';

import 'package:sana/core/networking/api_error_handler.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/core/services/app_update/data/models/update_config_model.dart';
import 'package:sana/core/services/app_update/data/services/app_update_service.dart';
import 'package:sana/core/utils/utils.dart';

abstract interface class IAppUpdateRepository {
  Future<Result<UpdateConfigModel?>> getCachedConfig();
  Future<Result<UpdateConfigModel>> fetchRemoteConfig();
  Future<Result<void>> cacheConfig(UpdateConfigModel config);
  Future<Result<String>> getCurrentVersion();
  Future<Result<void>> launchUpdateUrl(UpdateConfigModel? config);
}

class AppUpdateRepoImpl implements IAppUpdateRepository {
  AppUpdateRepoImpl(this._service);
  final IAppUpdateService _service;

  @override
  Future<Result<UpdateConfigModel?>> getCachedConfig() async {
    try {
      final config = await _service.getCachedConfig();
      return Result.success(config);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error('GetCachedConfig Error', error: e, stackTrace: stack),
      );
      return Result.failure(handleApiError(e));
    }
  }

  @override
  Future<Result<UpdateConfigModel>> fetchRemoteConfig() async {
    try {
      final config = await _service.fetchRemoteConfig();
      if (config == null) {
        return Result.failure(
          handleApiError(Exception('Null config fetched')),
        );
      }
      return Result.success(config);
    } on Exception catch (e) {
      unawaited(
        Future.microtask(() => AppLogger.warn('FetchRemoteConfig Error: $e')),
      );
      return Result.failure(handleApiError(e));
    }
  }

  @override
  Future<Result<void>> cacheConfig(UpdateConfigModel config) async {
    try {
      await _service.cacheConfig(config);
      return const Result.success(null);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error('CacheConfig Error', error: e, stackTrace: stack),
      );
      return Result.failure(handleApiError(e));
    }
  }

  @override
  Future<Result<String>> getCurrentVersion() async {
    try {
      final version = await _service.getCurrentVersion();
      return Result.success(version);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error('GetCurrentVersion Error', error: e, stackTrace: stack),
      );
      return Result.failure(handleApiError(e));
    }
  }

  @override
  Future<Result<void>> launchUpdateUrl(UpdateConfigModel? config) async {
    try {
      await _service.launchUpdateUrl(config);
      return const Result.success(null);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error('LaunchUpdateUrl Error', error: e, stackTrace: stack),
      );
      return Result.failure(handleApiError(e));
    }
  }
}
