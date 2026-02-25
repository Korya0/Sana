import 'package:equatable/equatable.dart';
import 'package:sana/features/app_update/data/models/app_update_config_keys.dart';

class UpdateConfigModel extends Equatable {
  const UpdateConfigModel({
    required this.latestVersion,
    required this.isForceUpdate,
    required this.updateUrl,
    this.updateMessage,
  });

  factory UpdateConfigModel.fromJson(Map<String, dynamic> json) {
    return UpdateConfigModel(
      latestVersion:
          (json[AppUpdateConfigKeys.latestVersion] as String?) ?? '1.0.0',
      isForceUpdate:
          (json[AppUpdateConfigKeys.isForceUpdate] as bool?) ?? false,
      updateUrl: (json[AppUpdateConfigKeys.updateUrl] as String?) ?? '',
      updateMessage: json[AppUpdateConfigKeys.updateMessage] as String?,
    );
  }

  final String latestVersion;
  final bool isForceUpdate;
  final String updateUrl;
  final String? updateMessage;

  Map<String, dynamic> toJson() {
    return {
      AppUpdateConfigKeys.latestVersion: latestVersion,
      AppUpdateConfigKeys.isForceUpdate: isForceUpdate,
      AppUpdateConfigKeys.updateUrl: updateUrl,
      AppUpdateConfigKeys.updateMessage: updateMessage,
    };
  }

  @override
  List<Object?> get props => [
    latestVersion,
    isForceUpdate,
    updateUrl,
    updateMessage,
  ];
}
