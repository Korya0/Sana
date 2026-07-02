import 'package:sana/core/constants/app_constants.dart';

class ShareConfig {
  const ShareConfig({
    this.department,
    this.imageName = AppConstants.defaultShareImageName,
  });

  factory ShareConfig.from({
    String? department,
    String imageName = AppConstants.defaultShareImageName,
  }) {
    return ShareConfig(
      department: department,
      imageName: imageName,
    );
  }

  final String? department;
  final String imageName;
}
