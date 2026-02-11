import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sana/features/app_update/data/models/update_config_model.dart';
import 'package:sana/features/app_update/data/services/app_update_service.dart';
import 'package:sana/features/app_update/presentation/controller/app_update_state.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateCubit extends Cubit<AppUpdateState> {
  final AppUpdateService _service;
  Timer? _retryTimer;

  AppUpdateCubit(this._service) : super(const AppUpdateState());

  Future<void> initialize() async {
    // 1. نحن نضع بيانات وهمية هنا (Fake Data) للتجربة الفورية
    if (!isClosed) {
      emit(
        state.copyWith(
          currentVersion: '0.0.1', // نسخة قديمة وهمية
          config: const UpdateConfigModel(
            latestVersion: '1.0.0', // نسخة جديدة موجودة على السيرفر
            forceStop:
                true, // اجعلها true لتجربة المنع، أو false لتجربة التنبيه (Banner)
            showBanner: true,
            message: "برجاء تحديث التطبيق لتجربة الميزة الجديدة",
            playStoreUrl:
                "https://play.google.com/store/apps/details?id=com.sana.muslim.app",
          ),
        ),
      );
    }
  }

  /*
  Future<void> initialize() async {
    // 1. Get App Version
    final info = await PackageInfo.fromPlatform();
    if (!isClosed) emit(state.copyWith(currentVersion: info.version));

    // 2. Load Cached Config (Instance check)
    try {
      final cachedConfig = await _service.getCachedConfig();
      if (cachedConfig != null && !isClosed) {
        emit(state.copyWith(config: cachedConfig));
      }
    } catch (_) {
      // Ignore cache errors
    }

    // 3. Fetch Remote Config
    await _fetchRemoteConfig();
  }
*/
  Future<void> _fetchRemoteConfig() async {
    try {
      final remoteConfig = await _service.fetchRemoteConfig();
      if (remoteConfig != null && !isClosed) {
        await _service.cacheConfig(remoteConfig);
        emit(state.copyWith(config: remoteConfig));
        _retryTimer?.cancel();
        _retryTimer = null;
      }
    } catch (e) {
      if (!isClosed && (_retryTimer == null || !_retryTimer!.isActive)) {
        // Retry every 10 seconds if failed
        _retryTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
          _retryFetchLoop();
        });
      }
    }
  }

  Future<void> _retryFetchLoop() async {
    try {
      final remoteConfig = await _service.fetchRemoteConfig();
      if (remoteConfig != null && !isClosed) {
        await _service.cacheConfig(remoteConfig);
        emit(state.copyWith(config: remoteConfig));
        _retryTimer?.cancel();
        _retryTimer = null;
      }
    } catch (_) {
      // Keep retrying silently
    }
  }

  Future<void> launchUpdateUrl() async {
    final url = state.config?.playStoreUrl;
    if (url != null && url.isNotEmpty) {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Future<void> close() {
    _retryTimer?.cancel();
    return super.close();
  }
}
