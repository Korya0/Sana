import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceInfoService {
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  Future<Map<String, dynamic>> getDeviceInfo() async {
    String deviceModel = 'Unknown';
    String osVersion = 'Unknown';

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

    final packageInfo = await PackageInfo.fromPlatform();

    return {
      'deviceModel': deviceModel,
      'osVersion': osVersion,
      'appVersion': packageInfo.version,
      'buildNumber': packageInfo.buildNumber,
      'platform': Platform.operatingSystem,
    };
  }
}
