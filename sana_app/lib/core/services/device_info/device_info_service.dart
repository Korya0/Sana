import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:package_info_plus/package_info_plus.dart';

abstract class IDeviceInfoService {
  Future<Map<String, dynamic>> getDeviceInfo();
  Future<int> getAndroidSdkInt();
}

class DeviceInfoServiceImpl implements IDeviceInfoService {
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  @override
  Future<Map<String, dynamic>> getDeviceInfo() async {
    var deviceModel = 'Unknown';
    var osVersion = 'Unknown';
    var platform = 'Unknown';

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
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfoPlugin.iosInfo;
        deviceModel = iosInfo.utsname.machine;
        osVersion = 'iOS ${iosInfo.systemVersion}';
      }
    }

    final packageInfo = await PackageInfo.fromPlatform();

    return {
      'deviceModel': deviceModel,
      'osVersion': osVersion,
      'appVersion': packageInfo.version,
      'buildNumber': packageInfo.buildNumber,
      'platform': platform,
    };
  }

  @override
  Future<int> getAndroidSdkInt() async {
    if (kIsWeb || !Platform.isAndroid) return 0;
    final androidInfo = await _deviceInfoPlugin.androidInfo;
    return androidInfo.version.sdkInt;
  }
}
