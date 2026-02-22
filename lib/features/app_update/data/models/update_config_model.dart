import 'package:equatable/equatable.dart';

class UpdateConfigModel extends Equatable {
  const UpdateConfigModel({
    required this.latestVersion,
    required this.isForceUpdate,
    required this.updateUrl,
  });

  factory UpdateConfigModel.fromJson(Map<String, dynamic> json) {
    return UpdateConfigModel(
      latestVersion: (json['latest_version'] as String?) ?? '1.0.0',
      isForceUpdate: (json['is_force_update'] as bool?) ?? false,
      updateUrl: (json['update_url'] as String?) ?? '',
    );
  }

  final String latestVersion;
  final bool isForceUpdate;
  final String updateUrl;

  Map<String, dynamic> toJson() {
    return {
      'latest_version': latestVersion,
      'is_force_update': isForceUpdate,
      'update_url': updateUrl,
    };
  }

  @override
  List<Object?> get props => [
    latestVersion,
    isForceUpdate,
    updateUrl,
  ];
}
