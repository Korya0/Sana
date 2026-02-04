import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:sana/core/services/force_update/update_config_model.dart';

class ForceUpdateState extends Equatable {
  final String currentVersion;
  final UpdateConfigModel? config;

  const ForceUpdateState({this.currentVersion = '0.0.0', this.config});

  ForceUpdateState copyWith({
    String? currentVersion,
    UpdateConfigModel? config,
  }) {
    return ForceUpdateState(
      currentVersion: currentVersion ?? this.currentVersion,
      config: config ?? this.config,
    );
  }

  @override
  List<Object?> get props => [currentVersion, config];

  bool get isUpdateRequired {
    if (kIsWeb) {
      return false; // [Web Support] لا نحتاج لفحص التحديثات الإجبارية في الويب
    }
    if (config == null || currentVersion == '0.0.0') return false;
    return _isVersionLessThan(currentVersion, config!.latestVersion);
  }

  bool _isVersionLessThan(String current, String latest) {
    try {
      final currentParts = current.split('.').map(int.parse).toList();
      final latestParts = latest.split('.').map(int.parse).toList();

      for (int i = 0; i < latestParts.length; i++) {
        final currentPart = i < currentParts.length ? currentParts[i] : 0;
        if (latestParts[i] > currentPart) return true;
        if (latestParts[i] < currentPart) return false;
      }
    } catch (_) {
      return current != latest;
    }
    return false;
  }
}
