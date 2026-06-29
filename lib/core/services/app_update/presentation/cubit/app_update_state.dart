import 'package:flutter/foundation.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/services/app_update/data/models/update_config_model.dart';
import 'package:sana/core/utils/utils.dart';

sealed class AppUpdateState {
  const AppUpdateState({
    this.currentVersion = AppConstants.defaultVersion,
    this.config,
  });

  final String currentVersion;
  final UpdateConfigModel? config;

  /// Whether any update is available (Current < Latest)
  bool get isUpdateAvailable {
    if (kIsWeb) return false;
    final cfg = config;
    if (cfg == null || currentVersion == AppConstants.defaultVersion) {
      return false;
    }

    return currentVersion.isVersionLessThan(cfg.latestVersion);
  }

  /// Whether the update is FORCED (Current < Min)
  bool get isForceUpdateRequired {
    if (kIsWeb) return false;
    final cfg = config;
    if (cfg == null || currentVersion == AppConstants.defaultVersion) {
      return false;
    }

    return currentVersion.isVersionLessThan(cfg.minVersion);
  }
}

class AppUpdateInitial extends AppUpdateState {
  const AppUpdateInitial({
    super.currentVersion = AppConstants.defaultVersion,
    super.config,
  });
}

class AppUpdateLoading extends AppUpdateState {
  const AppUpdateLoading({
    super.currentVersion = AppConstants.defaultVersion,
    super.config,
  });
}

class AppUpdateSuccess extends AppUpdateState {
  const AppUpdateSuccess({
    required super.currentVersion,
    required UpdateConfigModel config,
  }) : super(config: config);
}

class AppUpdateFailure extends AppUpdateState {
  const AppUpdateFailure({
    required this.errorMessage,
    super.currentVersion = AppConstants.defaultVersion,
    super.config,
  });

  final String errorMessage;
}
