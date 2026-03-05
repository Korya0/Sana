import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sana/core/constants/app_links.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/app_update/data/repositories/app_update_repository.dart';
import 'package:sana/features/app_update/presentation/controller/app_update_state.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateCubit extends Cubit<AppUpdateState> {
  AppUpdateCubit(this._repository) : super(const AppUpdateState()) {
    unawaited(initialize());
  }
  final IAppUpdateRepository _repository;

  Future<void> initialize() async {
    // 1. Get App Version
    try {
      final info = await PackageInfo.fromPlatform();
      if (!isClosed) emit(state.copyWith(currentVersion: info.version));
    } catch (e, stack) {
      unawaited(
        AppLogger.error(
          'Error getting package info',
          error: e,
          stackTrace: stack,
        ),
      );
    }

    // 2. Load Cached Config
    final cachedResult = await _repository.getCachedConfig();
    cachedResult.fold(
      (failure) => unawaited(
        AppLogger.error(
          'Error loading cached update config: ${failure.message}',
        ),
      ),
      (cachedConfig) {
        if (cachedConfig != null && !isClosed) {
          emit(state.copyWith(config: cachedConfig));
        }
      },
    );

    // 3. Fetch Remote Config
    final remoteResult = await _repository.fetchRemoteConfig();
    remoteResult.fold(
      (failure) => unawaited(
        AppLogger.error(
          'Error fetching remote update config: ${failure.message}',
        ),
      ),
      (remoteConfig) async {
        if (!isClosed) {
          emit(state.copyWith(config: remoteConfig));
          // Cache the new config
          await _repository.cacheConfig(remoteConfig);
        }
      },
    );
  }

  Future<void> launchUpdateUrl() async {
    final url = (state.config != null && state.config!.updateUrl.isNotEmpty)
        ? state.config!.updateUrl
        : AppLinks.playStore;

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
