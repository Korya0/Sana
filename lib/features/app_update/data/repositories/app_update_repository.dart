import 'dart:async';

import 'package:sana/core/networking/api_error_handler.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/features/app_update/data/models/update_config_model.dart';
import 'package:sana/features/app_update/data/datasources/app_update_data_source.dart';

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
    final config = await _service.getCachedConfig();
    return Result.success(config);
  }

  @override
  Future<Result<UpdateConfigModel>> fetchRemoteConfig() async {
    final config = await _service.fetchRemoteConfig();
    if (config == null) {
      return Result.failure(
        handleApiError(Exception('Null config fetched')),
      );
    }

    await _service.cacheConfig(config);
    return Result.success(config);
  }

  @override
  Future<Result<void>> cacheConfig(UpdateConfigModel config) async {
    await _service.cacheConfig(config);
    return const Result.success(null);
  }

  @override
  Future<Result<String>> getCurrentVersion() async {
    final version = await _service.getCurrentVersion();
    return Result.success(version);
  }

  @override
  Future<Result<void>> launchUpdateUrl(UpdateConfigModel? config) async {
    await _service.launchUpdateUrl(config);
    return const Result.success(null);
  }
}
