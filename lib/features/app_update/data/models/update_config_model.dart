import 'package:equatable/equatable.dart';
import 'package:sana/features/app_update/data/constants/remote_config_keys.dart';

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
          (json[RemoteConfigKeys.latestVersion] as String?) ?? '1.0.0',
      isForceUpdate: (json[RemoteConfigKeys.isForceUpdate] as bool?) ?? false,
      updateUrl: (json[RemoteConfigKeys.updateUrl] as String?) ?? '',
      updateMessage: json[RemoteConfigKeys.updateMessage] as String?,
    );
  }

  final String latestVersion;
  final bool isForceUpdate;
  final String updateUrl;
  final String? updateMessage;

  Map<String, dynamic> toJson() {
    return {
      RemoteConfigKeys.latestVersion: latestVersion,
      RemoteConfigKeys.isForceUpdate: isForceUpdate,
      RemoteConfigKeys.updateUrl: updateUrl,
      RemoteConfigKeys.updateMessage: updateMessage,
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
