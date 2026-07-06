import 'package:sana/core/constants/constants.dart';
import 'package:sana/features/app_update/data/constants/remote_config_keys.dart';
import 'package:flutter/foundation.dart';

@immutable
class UpdateConfigModel {
  const UpdateConfigModel({
    required this.latestVersion,
    required this.minVersion,
    required this.updateUrl,
    this.updateMessage,
  });

  factory UpdateConfigModel.fromJson(Map<String, dynamic> json) {
    return UpdateConfigModel(
      latestVersion:
          (json[RemoteConfigKeys.latestVersion] as String?) ??
          AppConstants.defaultVersion,
      minVersion:
          (json[RemoteConfigKeys.minVersion] as String?) ??
          AppConstants.defaultVersion,
      updateUrl: (json[RemoteConfigKeys.updateUrl] as String?) ?? '',
      updateMessage: json[RemoteConfigKeys.updateMessage] as String?,
    );
  }

  final String latestVersion;
  final String minVersion;
  final String updateUrl;
  final String? updateMessage;

  Map<String, dynamic> toJson() {
    return {
      RemoteConfigKeys.latestVersion: latestVersion,
      RemoteConfigKeys.minVersion: minVersion,
      RemoteConfigKeys.updateUrl: updateUrl,
      RemoteConfigKeys.updateMessage: updateMessage,
    };
  }

  UpdateConfigModel copyWith({
    String? latestVersion,
    String? minVersion,
    String? updateUrl,
    String? updateMessage,
  }) {
    return UpdateConfigModel(
      latestVersion: latestVersion ?? this.latestVersion,
      minVersion: minVersion ?? this.minVersion,
      updateUrl: updateUrl ?? this.updateUrl,
      updateMessage: updateMessage ?? this.updateMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UpdateConfigModel &&
        other.latestVersion == latestVersion &&
        other.minVersion == minVersion &&
        other.updateUrl == updateUrl &&
        other.updateMessage == updateMessage;
  }

  @override
  int get hashCode => Object.hash(
    latestVersion,
    minVersion,
    updateUrl,
    updateMessage,
  );
}
