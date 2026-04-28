import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/networking/api_result.dart';
import 'package:sana/core/services/app_update/data/repositories/app_update_repository.dart';
import 'package:sana/core/services/app_update/presentation/cubit/app_update_state.dart';

class AppUpdateCubit extends Cubit<AppUpdateState> {
  AppUpdateCubit(this._repository) : super(const AppUpdateInitial()) {
    unawaited(initialize());
  }

  final IAppUpdateRepository _repository;

  Future<void> initialize() async {
    emit(const AppUpdateLoading());

    // 1. Get App Version from repository
    final versionResult = await _repository.getCurrentVersion();
    final currentVersion = switch (versionResult) {
      Success(data: final v) => v,
      ApiFailure() => '', // Default or handle error
    };

    // 2. Load Cached Config as immediate fallback
    final cachedResult = await _repository.getCachedConfig();

    switch (cachedResult) {
      case Success(data: final cachedConfig):
        if (cachedConfig != null && !isClosed) {
          emit(
            AppUpdateSuccess(
              currentVersion: currentVersion,
              config: cachedConfig,
            ),
          );
        }
      case ApiFailure():
        // Ignore failure for cache, wait for remote
        break;
    }

    // 3. Fetch Remote Config
    final remoteResult = await _repository.fetchRemoteConfig();

    switch (remoteResult) {
      case Success(data: final remoteConfig):
        if (!isClosed) {
          emit(
            AppUpdateSuccess(
              currentVersion: currentVersion,
              config: remoteConfig,
            ),
          );
          // Cache the new config
          await _repository.cacheConfig(remoteConfig);
        }
      case ApiFailure(:final failure):
        if (state is! AppUpdateSuccess && !isClosed) {
          emit(
            AppUpdateFailure(
              errorMessage: failure.message,
              currentVersion: currentVersion,
            ),
          );
        }
    }
  }

  Future<void> launchUpdateUrl() async {
    await _repository.launchUpdateUrl(state.config);
  }
}
