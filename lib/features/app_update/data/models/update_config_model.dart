import 'package:equatable/equatable.dart';
import 'package:sana/core/constants/config_keys.dart';

class UpdateConfigModel extends Equatable {
  const UpdateConfigModel({
    required this.latestVersion,
    required this.isForceUpdate,
    required this.updateUrl,
    this.updateMessage,
  });

  factory UpdateConfigModel.fromJson(Map<String, dynamic> json) {
    return UpdateConfigModel(
      latestVersion: (json[ConfigKeys.latestVersion] as String?) ?? '1.0.0',
      isForceUpdate: (json[ConfigKeys.isForceUpdate] as bool?) ?? false,
      updateUrl: (json[ConfigKeys.updateUrl] as String?) ?? '',
      updateMessage: json[ConfigKeys.updateMessage] as String?,
    );
  }

  final String latestVersion;
  final bool isForceUpdate;
  final String updateUrl;
  final String? updateMessage;

  Map<String, dynamic> toJson() {
    return {
      ConfigKeys.latestVersion: latestVersion,
      ConfigKeys.isForceUpdate: isForceUpdate,
      ConfigKeys.updateUrl: updateUrl,
      ConfigKeys.updateMessage: updateMessage,
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
