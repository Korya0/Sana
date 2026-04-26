import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sana/core/services/app_update/data/models/update_config_model.dart';
import 'package:sana/core/utils/version_utils.dart';

part 'app_update_state.freezed.dart';

@freezed
class AppUpdateState with _$AppUpdateState {
  const AppUpdateState._();

  const factory AppUpdateState.initial({
    @Default('0.0.0+0') String currentVersion,
    UpdateConfigModel? config,
  }) = AppUpdateInitial;

  const factory AppUpdateState.loading({
    @Default('0.0.0+0') String currentVersion,
    UpdateConfigModel? config,
  }) = AppUpdateLoading;

  const factory AppUpdateState.success({
    required String currentVersion,
    required UpdateConfigModel config,
  }) = AppUpdateSuccess;

  const factory AppUpdateState.failure({
    required String errorMessage,
    @Default('0.0.0+0') String currentVersion,
    UpdateConfigModel? config,
  }) = AppUpdateFailure;

  /// يفرق بين Android و iOS ويقارن الإصدار المخصص لكل منصة.
  /// يشمل المقارنة الـ build number بعد '+'.
  bool get isUpdateRequired {
    if (kIsWeb) return false;
    final version = currentVersion;
    final cfg = config;
    if (cfg == null || version == '0.0.0+0') return false;

    final latestForPlatform = defaultTargetPlatform == TargetPlatform.iOS
        ? cfg.latestVersionIos
        : cfg.latestVersion;

    return VersionUtils.isVersionLessThan(version, latestForPlatform);
  }
}
