import 'package:flutter/foundation.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/features/app_update/data/models/update_config_model.dart';
import 'package:sana/core/utils/utils.dart';

@immutable
sealed class AppUpdateState {
  const AppUpdateState({
    this.currentVersion = AppConstants.defaultVersion,
    this.config,
  });

  final String currentVersion;
  final UpdateConfigModel? config;

  bool get isUpdateAvailable {
    if (kIsWeb && !kDebugMode) return false;
    final cfg = config;
    if (cfg == null || currentVersion == AppConstants.defaultVersion) {
      return false;
    }

    return currentVersion.isVersionLessThan(cfg.latestVersion);
  }

  bool get isForceUpdateRequired {
    if (kIsWeb && !kDebugMode) return false;
    final cfg = config;
    if (cfg == null || currentVersion == AppConstants.defaultVersion) {
      return false;
    }

    return currentVersion.isVersionLessThan(cfg.minVersion);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppUpdateState &&
        other.runtimeType == runtimeType &&
        other.currentVersion == currentVersion &&
        other.config == config;
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentVersion, config);
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppUpdateFailure &&
        other.currentVersion == currentVersion &&
        other.config == config &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    currentVersion,
    config,
    errorMessage,
  );
}
