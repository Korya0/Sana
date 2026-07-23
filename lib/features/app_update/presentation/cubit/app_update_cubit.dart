import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/network/result.dart';
import 'package:sana/features/app_update/data/repositories/app_update_repository.dart';
import 'package:sana/features/app_update/presentation/cubit/app_update_state.dart';

class AppUpdateCubit extends Cubit<AppUpdateState> {
  AppUpdateCubit(this._repository) : super(const AppUpdateInitial());

  final IAppUpdateRepository _repository;

  void initialize() {
    unawaited(_initialize());
  }

  Future<void> _initialize() async {
    emit(const AppUpdateLoading());

    final versionResult = await _repository.getCurrentVersion();
    final currentVersion = switch (versionResult) {
      Success(data: final v) => v,
      FailureResult() => '',
    };

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
      case FailureResult():
        break;
    }

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
        }
      case FailureResult(:final failure):
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
