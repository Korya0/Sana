import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

enum AppPermissionType {
  notification,
  location,
  camera,
  exactAlarm,
}

enum AppPermissionStatus {
  denied,
  granted,
  restricted,
  limited,
  permanentlyDenied,
}

abstract interface class IAppPermissionsManager {
  Future<AppPermissionStatus> checkPermission(AppPermissionType permission);
  Future<AppPermissionStatus> requestPermission(AppPermissionType permission);
  Future<bool> openSettings();

  // Helper methods for common permissions
  Future<bool> isNotificationGranted();
  Future<bool> isLocationGranted();
  Future<bool> isCameraGranted();
  Future<bool> isExactAlarmGranted();
  Future<bool> requestExactAlarmPermission();
  Future<bool> requestNotificationPermission();
}

class AppPermissionsManagerImpl implements IAppPermissionsManager {
  Permission _mapPermissionType(AppPermissionType type) {
    return switch (type) {
      AppPermissionType.notification => Permission.notification,
      AppPermissionType.location => Permission.location,
      AppPermissionType.camera => Permission.camera,
      AppPermissionType.exactAlarm => Permission.scheduleExactAlarm,
    };
  }

  AppPermissionStatus _mapPermissionStatus(PermissionStatus status) {
    return switch (status) {
      PermissionStatus.denied => AppPermissionStatus.denied,
      PermissionStatus.granted => AppPermissionStatus.granted,
      PermissionStatus.restricted => AppPermissionStatus.restricted,
      PermissionStatus.limited => AppPermissionStatus.limited,
      PermissionStatus.permanentlyDenied =>
        AppPermissionStatus.permanentlyDenied,
      PermissionStatus.provisional => AppPermissionStatus.granted,
    };
  }

  @override
  Future<AppPermissionStatus> checkPermission(
    AppPermissionType permission,
  ) async {
    final status = await _mapPermissionType(permission).status;
    return _mapPermissionStatus(status);
  }

  @override
  Future<AppPermissionStatus> requestPermission(
    AppPermissionType permission,
  ) async {
    final status = await _mapPermissionType(permission).request();
    return _mapPermissionStatus(status);
  }

  @override
  Future<bool> openSettings() async {
    if (kIsWeb) return false;
    return openAppSettings();
  }

  @override
  Future<bool> isNotificationGranted() async {
    final status = await checkPermission(AppPermissionType.notification);
    return status == AppPermissionStatus.granted;
  }

  @override
  Future<bool> isLocationGranted() async {
    final status = await checkPermission(AppPermissionType.location);
    return status == AppPermissionStatus.granted;
  }

  @override
  Future<bool> isCameraGranted() async {
    final status = await checkPermission(AppPermissionType.camera);
    return status == AppPermissionStatus.granted;
  }

  @override
  Future<bool> isExactAlarmGranted() async {
    final status = await checkPermission(AppPermissionType.exactAlarm);
    return status == AppPermissionStatus.granted;
  }

  @override
  Future<bool> requestExactAlarmPermission() async {
    final status = await checkPermission(AppPermissionType.exactAlarm);
    if (status == AppPermissionStatus.denied) {
      final result = await requestPermission(AppPermissionType.exactAlarm);
      return result == AppPermissionStatus.granted;
    }
    return status == AppPermissionStatus.granted;
  }

  @override
  Future<bool> requestNotificationPermission() async {
    final status = await requestPermission(AppPermissionType.notification);
    return status == AppPermissionStatus.granted;
  }
}
