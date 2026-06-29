import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/services/app_update/data/constants/remote_config_keys.dart';

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
}
