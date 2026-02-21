import 'package:equatable/equatable.dart';

class UpdateConfigModel extends Equatable {
  const UpdateConfigModel({
    required this.latestVersion,
    required this.forceStop,
    required this.showBanner,
    required this.message,
    required this.playStoreUrl,
  });

  factory UpdateConfigModel.fromJson(Map<String, dynamic> json) {
    return UpdateConfigModel(
      latestVersion: (json['latest_version'] as String?) ?? '0.0.0',
      forceStop: (json['force_stop'] as bool?) ?? false,
      showBanner: (json['show_banner'] as bool?) ?? false,
      message: (json['message'] as String?) ?? '',
      playStoreUrl: (json['play_store_url'] as String?) ?? '',
    );
  }
  final String latestVersion;
  final bool forceStop;
  final bool showBanner;
  final String message;
  final String playStoreUrl;

  Map<String, dynamic> toJson() {
    return {
      'latest_version': latestVersion,
      'force_stop': forceStop,
      'show_banner': showBanner,
      'message': message,
      'play_store_url': playStoreUrl,
    };
  }

  @override
  List<Object?> get props => [
    latestVersion,
    forceStop,
    showBanner,
    message,
    playStoreUrl,
  ];
}
