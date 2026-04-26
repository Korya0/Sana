import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sana/core/constants/app_links.dart';
import 'package:sana/core/services/app_update/data/repositories/app_update_repository.dart';
import 'package:sana/core/services/app_update/presentation/controller/app_update_state.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateCubit extends Cubit<AppUpdateState> {
  AppUpdateCubit(this._repository) : super(const AppUpdateState.initial()) {
    unawaited(initialize());
  }
  final IAppUpdateRepository _repository;

  Future<void> initialize() async {
    emit(const AppUpdateState.loading());

    var currentVersion = '0.0.0+0';

    // 1. Get App Version — يبني '1.0.0+4' لمقارنة دقيقة تشمل build number
    try {
      final info = await PackageInfo.fromPlatform();
      final build = info.buildNumber.isNotEmpty ? info.buildNumber : '0';
      currentVersion = '${info.version}+$build';
    } on Exception catch (e, stack) {
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
    cachedResult.when(
      success: (cachedConfig) {
        if (cachedConfig != null && !isClosed) {
          emit(
            AppUpdateState.success(
              currentVersion: currentVersion,
              config: cachedConfig,
            ),
          );
        }
      },
      failure: (_) {}, // Ignore failure for cache, wait for remote
    );

    // 3. Fetch Remote Config
    final remoteResult = await _repository.fetchRemoteConfig();
    await remoteResult.when(
      success: (remoteConfig) async {
        if (!isClosed) {
          emit(
            AppUpdateState.success(
              currentVersion: currentVersion,
              config: remoteConfig,
            ),
          );
          // Cache the new config
          await _repository.cacheConfig(remoteConfig);
        }
      },
      failure: (failure) async {
        if (state is! AppUpdateSuccess) {
          emit(
            AppUpdateState.failure(
              errorMessage: failure.message,
              currentVersion: currentVersion,
            ),
          );
        }
      },
    );
  }

  Future<void> launchUpdateUrl() async {
    final config = state.config;

    String url;
    if (config != null) {
      // iOS → use updateUrlIos if available, else fallback
      // Android → use updateUrl if available, else fallback
      final platformUrl = defaultTargetPlatform == TargetPlatform.iOS
          ? config.updateUrlIos
          : config.updateUrl;
      url = platformUrl.isNotEmpty ? platformUrl : AppLinks.storeLink;
    } else {
      url = AppLinks.storeLink;
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
