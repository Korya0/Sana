import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:package_info_plus/package_info_plus.dart';

class DeviceInfoService {
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

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
}
