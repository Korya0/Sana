import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/features/app_update/data/models/update_config_model.dart';
import 'package:sana/features/app_update/data/services/app_update_service.dart';
import 'package:sana/features/app_update/presentation/controller/app_update_state.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateCubit extends Cubit<AppUpdateState> {
  AppUpdateCubit(this._service) : super(const AppUpdateState());
  final AppUpdateService _service;
  StreamSubscription<UpdateConfigModel?>? _configSubscription;

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

    // 3. Start Listening to Remote Config
    await _startListeningToRemoteConfig();
  }

  Future<void> _startListeningToRemoteConfig() async {
    await _configSubscription?.cancel();
    _configSubscription = _service.listenToRemoteConfig().listen(
      (remoteConfig) async {
        if (remoteConfig != null && !isClosed) {
          //  remove this
          // ignore: avoid_print
          print('AppUpdateCubit: Real-time config received');
          //  remove this
          // ignore: avoid_print
          print(
            'AppUpdateCubit: Current: ${state.currentVersion}, Server: ${remoteConfig.latestVersion}',
          );
          emit(state.copyWith(config: remoteConfig));

          // Cache the new config
          await _service.cacheConfig(remoteConfig);
        }
      },
      onError: (Object error) {
        //  remove this
        // ignore: avoid_print
        print('AppUpdateCubit: Stream error: $error');
      },
    );
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
  Future<void> close() async {
    await _configSubscription?.cancel();
    return super.close();
  }
}
