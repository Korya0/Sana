import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:sana/features/app_update/data/models/update_config_model.dart';

class AppUpdateState extends Equatable {
  const AppUpdateState({this.currentVersion = '0.0.0', this.config});
  final String currentVersion;
  final UpdateConfigModel? config;

  AppUpdateState copyWith({String? currentVersion, UpdateConfigModel? config}) {
    return AppUpdateState(
      currentVersion: currentVersion ?? this.currentVersion,
      config: config ?? this.config,
    );
  }

  @override
  List<Object?> get props => [currentVersion, config];

  bool get isUpdateRequired {
    // 1. Web doesn't need mandatory app updates
    if (kIsWeb) return false;

    // 2. Ensuring we have the required data
    if (config == null || currentVersion == '0.0.0') return false;

    // 3. Compare current version with latest version from remote config
    return _isVersionLessThan(currentVersion, config!.latestVersion);
  }

  /// Compares two version strings (e.g., '1.0.0' and '1.0.1')
  bool _isVersionLessThan(String current, String latest) {
    try {
      // إزالة رقم البناء (Build Number) مثل +1 أو أي إضافات مثل -alpha
      final cleanCurrent = current.split('+')[0].split('-')[0];
      final cleanLatest = latest.split('+')[0].split('-')[0];

      final v1 = cleanCurrent.split('.').map(int.parse).toList();
      final v2 = cleanLatest.split('.').map(int.parse).toList();

      for (var i = 0; i < v1.length && i < v2.length; i++) {
        if (v1[i] < v2[i]) return true;
        if (v1[i] > v2[i]) return false;
      }
      return v2.length > v1.length;
    } on FormatException catch (_) {
      return false; // Safely return false if version format is invalid
    }
  }
}
