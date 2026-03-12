import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:sana/core/utils/version_utils.dart';
import 'package:sana/features/app_update/data/models/update_config_model.dart';

sealed class AppUpdateState extends Equatable {
  const AppUpdateState({this.currentVersion = '0.0.0', this.config});

  final String currentVersion;
  final UpdateConfigModel? config;

  @override
  List<Object?> get props => [currentVersion, config];

  bool get isUpdateRequired {
    if (kIsWeb) return false;
    if (config == null || currentVersion == '0.0.0') return false;
    return VersionUtils.isVersionLessThan(currentVersion, config!.latestVersion);
  }
}

class AppUpdateInitial extends AppUpdateState {
  const AppUpdateInitial() : super();
}

class AppUpdateLoading extends AppUpdateState {
  const AppUpdateLoading({super.currentVersion, super.config});
}

class AppUpdateSuccess extends AppUpdateState {
  const AppUpdateSuccess({required super.currentVersion, required super.config});
}

class AppUpdateFailure extends AppUpdateState {
  const AppUpdateFailure({
    required this.errorMessage,
    super.currentVersion,
    super.config,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, currentVersion, config];
}
