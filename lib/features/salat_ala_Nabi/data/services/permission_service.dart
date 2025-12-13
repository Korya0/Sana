import 'package:permission_handler/permission_handler.dart';

/// Service for managing app permissions
class PermissionService {
  /// Request notification permission only
  static Future<bool> requestNotificationPermission() async {
    var notificationStatus = await Permission.notification.status;

    if (notificationStatus.isDenied) {
      notificationStatus = await Permission.notification.request();
    }

    if (notificationStatus.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }

    return notificationStatus.isGranted;
  }

  /// Request all necessary permissions
  static Future<bool> requestAllPermissions() async {
    // Request notification permission (Android 13+)
    final notificationStatus = await Permission.notification.request();

    // Only require notification permission
    return notificationStatus.isGranted;
  }

  /// Check if exact alarm permission is granted (Android 12+)
  static Future<bool> checkExactAlarmPermission() async {
    return await Permission.scheduleExactAlarm.isGranted;
  }

  /// Request exact alarm permission
  static Future<bool> requestExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    if (status.isDenied) {
      final result = await Permission.scheduleExactAlarm.request();
      return result.isGranted;
    }
    return status.isGranted;
  }

  static Future<void> openSettings() async {
    await openAppSettings();
  }
}
