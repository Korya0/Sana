import 'package:equatable/equatable.dart';

/// Model representing the remote update configuration
class UpdateConfigModel extends Equatable {
  final String latestVersion;
  final bool forceStop;
  final bool showBanner;
  final String message;

  const UpdateConfigModel({
    required this.latestVersion,
    required this.forceStop,
    required this.showBanner,
    required this.message,
  });

  factory UpdateConfigModel.fromJson(Map<String, dynamic> json) {
    return UpdateConfigModel(
      latestVersion: json['latest_version'] ?? '0.0.0',
      forceStop: json['force_stop'] ?? false,
      showBanner: json['show_banner'] ?? false,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latest_version': latestVersion,
      'force_stop': forceStop,
      'show_banner': showBanner,
      'message': message,
    };
  }

  @override
  List<Object?> get props => [latestVersion, forceStop, showBanner, message];
}
