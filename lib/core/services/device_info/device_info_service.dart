import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:package_info_plus/package_info_plus.dart';

class DeviceInfoModel {
  const DeviceInfoModel({
    required this.deviceModel,
    required this.osVersion,
    required this.appVersion,
    required this.buildNumber,
    required this.platform,
    this.osApiLevel,
  });

  final String deviceModel;
  final String osVersion;
  final String appVersion;
  final String buildNumber;
  final String platform;
  final int? osApiLevel;

  Map<String, dynamic> toJson() {
    return {
      'deviceModel': deviceModel,
      'osVersion': osVersion,
      'appVersion': appVersion,
      'buildNumber': buildNumber,
      'platform': platform,
      if (osApiLevel != null) 'osApiLevel': osApiLevel,
    };
  }
}

abstract interface class DeviceInfoService {
  Future<DeviceInfoModel> getDeviceInfo();
}

class DeviceInfoServiceImpl implements DeviceInfoService {
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  @override
  Future<DeviceInfoModel> getDeviceInfo() async {
    var deviceModel = 'Unknown';
    var osVersion = 'Unknown';
    var platform = 'Unknown';
    int? osApiLevel;

    if (kIsWeb) {
      final webInfo = await _deviceInfoPlugin.webBrowserInfo;
      deviceModel = webInfo.browserName.name;
      osVersion = webInfo.userAgent ?? 'Unknown';
      platform = 'web';
    } else {
      platform = Platform.operatingSystem;
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfoPlugin.androidInfo;
        deviceModel = '${androidInfo.manufacturer} ${androidInfo.model}';
        osVersion =
            'Android ${androidInfo.version.release} (SDK ${androidInfo.version.sdkInt})';
        osApiLevel = androidInfo.version.sdkInt;
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfoPlugin.iosInfo;
        deviceModel = iosInfo.utsname.machine;
        osVersion = 'iOS ${iosInfo.systemVersion}';
      }
    }

    final packageInfo = await PackageInfo.fromPlatform();

    return DeviceInfoModel(
      deviceModel: deviceModel,
      osVersion: osVersion,
      appVersion: packageInfo.version,
      buildNumber: packageInfo.buildNumber,
      platform: platform,
      osApiLevel: osApiLevel,
    );
  }
}
