import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sana/core/constants/app_links.dart';
import 'package:sana/features/app_update/data/services/app_update_service.dart';
import 'package:sana/features/app_update/presentation/controller/app_update_state.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateCubit extends Cubit<AppUpdateState> {
  AppUpdateCubit(this._service) : super(const AppUpdateState()) {
    unawaited(initialize());
  }
  final AppUpdateService _service;

  Future<void> initialize() async {
    // 1. Get App Version
    final info = await PackageInfo.fromPlatform();
    if (!isClosed) emit(state.copyWith(currentVersion: info.version));

    // 2. Load Cached Config
    try {
      final cachedConfig = await _service.getCachedConfig();
      if (cachedConfig != null && !isClosed) {
        emit(state.copyWith(config: cachedConfig));
      }
    } on Exception catch (_) {}

    // 3. Fetch Remote Config (Sequential, not a Stream)
    try {
      final remoteConfig = await _service.fetchRemoteConfig();
      if (remoteConfig != null && !isClosed) {
        emit(state.copyWith(config: remoteConfig));
        // Cache the new config
        await _service.cacheConfig(remoteConfig);
      }
    } on Exception catch (_) {}
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
