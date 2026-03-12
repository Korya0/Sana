import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sana/core/constants/app_links.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/app_update/data/repositories/app_update_repository.dart';
import 'package:sana/features/app_update/presentation/controller/app_update_state.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateCubit extends Cubit<AppUpdateState> {
  AppUpdateCubit(this._repository) : super(const AppUpdateInitial()) {
    unawaited(initialize());
  }
  final IAppUpdateRepository _repository;

  Future<void> initialize() async {
    emit(const AppUpdateLoading());
    
    String currentVersion = '0.0.0';

    // 1. Get App Version
    try {
      final info = await PackageInfo.fromPlatform();
      currentVersion = info.version;
    } catch (e, stack) {
      unawaited(
        AppLogger.error(
          'Error getting package info',
          error: e,
          stackTrace: stack,
        ),
      );
    }

    // 2. Load Cached Config as immediate fallback
    final cachedResult = await _repository.getCachedConfig();
    cachedResult.fold(
      (_) {}, // Ignore failure for cache, wait for remote
      (cachedConfig) {
        if (cachedConfig != null && !isClosed) {
          emit(AppUpdateSuccess(currentVersion: currentVersion, config: cachedConfig));
        }
      },
    );

    // 3. Fetch Remote Config
    final remoteResult = await _repository.fetchRemoteConfig();
    await remoteResult.fold(
      (failure) async {
        if (state is! AppUpdateSuccess) {
          emit(AppUpdateFailure(
            errorMessage: failure.message,
            currentVersion: currentVersion,
          ));
        }
      },
      (remoteConfig) async {
        if (!isClosed) {
          emit(AppUpdateSuccess(currentVersion: currentVersion, config: remoteConfig));
          // Cache the new config
          await _repository.cacheConfig(remoteConfig);
        }
      },
    );
  }

  Future<void> launchUpdateUrl() async {
    final config = state.config;
    final url = (config != null && config.updateUrl.isNotEmpty)
        ? config.updateUrl
        : AppLinks.playStore;

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
