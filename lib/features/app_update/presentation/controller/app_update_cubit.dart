import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/features/app_update/data/services/app_update_service.dart';
import 'package:sana/features/app_update/presentation/controller/app_update_state.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateCubit extends Cubit<AppUpdateState> {
  AppUpdateCubit(this._service) : super(const AppUpdateState());
  final AppUpdateService _service;
  Timer? _retryTimer;

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
    } on FormatException catch (_) {
      // Ignore cache errors
    }

    // 3. Fetch Remote Config
    await _fetchRemoteConfig();
  }

  Future<void> _fetchRemoteConfig() async {
    try {
      final remoteConfig = await _service.fetchRemoteConfig();
      if (remoteConfig != null && !isClosed) {
        emit(state.copyWith(config: remoteConfig));
        _stopRetryTimer();
      }
    } on FormatException catch (_) {
      _startRetryTimer();
    }
  }

  void _startRetryTimer() {
    if (!isClosed && (_retryTimer == null || !_retryTimer!.isActive)) {
      _retryTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
        await _retryFetchLoop();
      });
    }
  }

  void _stopRetryTimer() {
    _retryTimer?.cancel();
    _retryTimer = null;
  }

  Future<void> _retryFetchLoop() async {
    try {
      final remoteConfig = await _service.fetchRemoteConfig();
      if (remoteConfig != null && !isClosed) {
        emit(state.copyWith(config: remoteConfig));
        _stopRetryTimer();
      }
    } on FormatException catch (_) {}
  }

  Future<void> launchUpdateUrl() async {
    final url = (state.config != null && state.config!.playStoreUrl.isNotEmpty)
        ? state.config!.playStoreUrl
        : AppConstants.playStoreUrl;

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Future<void> close() {
    _retryTimer?.cancel();
    return super.close();
  }
}
