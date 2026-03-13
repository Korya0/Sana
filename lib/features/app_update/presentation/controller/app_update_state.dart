import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sana/core/utils/version_utils.dart';
import 'package:sana/features/app_update/data/models/update_config_model.dart';

part 'app_update_state.freezed.dart';

@freezed
class AppUpdateState with _$AppUpdateState {
  const AppUpdateState._();

  const factory AppUpdateState.initial({
    @Default('0.0.0') String currentVersion,
    UpdateConfigModel? config,
  }) = AppUpdateInitial;

  const factory AppUpdateState.loading({
    @Default('0.0.0') String currentVersion,
    UpdateConfigModel? config,
  }) = AppUpdateLoading;

  const factory AppUpdateState.success({
    required String currentVersion,
    required UpdateConfigModel config,
  }) = AppUpdateSuccess;

  const factory AppUpdateState.failure({
    required String errorMessage,
    @Default('0.0.0') String currentVersion,
    UpdateConfigModel? config,
  }) = AppUpdateFailure;

  bool get isUpdateRequired {
    if (kIsWeb) return false;
    final version = currentVersion;
    final cfg = config;
    if (cfg == null || version == '0.0.0') return false;
    return VersionUtils.isVersionLessThan(version, cfg.latestVersion);
  }
}
