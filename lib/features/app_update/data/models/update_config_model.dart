import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sana/features/app_update/data/constants/remote_config_keys.dart';

part 'update_config_model.freezed.dart';

@freezed
class UpdateConfigModel with _$UpdateConfigModel {
  const factory UpdateConfigModel({
    required String latestVersion,
    required String latestVersionIos,
    required bool isForceUpdate,
    required String updateUrl,
    @Default('') String updateUrlIos,
    String? updateMessage,
  }) = _UpdateConfigModel;

  const UpdateConfigModel._();

  factory UpdateConfigModel.fromJson(Map<String, dynamic> json) {
    return UpdateConfigModel(
      latestVersion:
          (json[RemoteConfigKeys.latestVersion] as String?) ?? '1.1.0+5',
      latestVersionIos:
          (json[RemoteConfigKeys.latestVersionIos] as String?) ?? '1.0.0',
      isForceUpdate: (json[RemoteConfigKeys.isForceUpdate] as bool?) ?? false,
      updateUrl: (json[RemoteConfigKeys.updateUrl] as String?) ?? '',
      updateUrlIos: (json[RemoteConfigKeys.updateUrlIos] as String?) ?? '',
      updateMessage: json[RemoteConfigKeys.updateMessage] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      RemoteConfigKeys.latestVersion: latestVersion,
      RemoteConfigKeys.latestVersionIos: latestVersionIos,
      RemoteConfigKeys.isForceUpdate: isForceUpdate,
      RemoteConfigKeys.updateUrl: updateUrl,
      RemoteConfigKeys.updateUrlIos: updateUrlIos,
      RemoteConfigKeys.updateMessage: updateMessage,
    };
  }
}

