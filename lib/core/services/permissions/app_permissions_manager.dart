import 'package:permission_handler/permission_handler.dart';

abstract class IAppPermissionsManager {
  Future<PermissionStatus> checkPermission(Permission permission);
  Future<PermissionStatus> requestPermission(Permission permission);
  Future<bool> openSettings();

  // Helper methods for common permissions
  Future<bool> isNotificationGranted();
  Future<bool> isLocationGranted();
  Future<bool> isCameraGranted();
}

class AppPermissionsManagerImpl implements IAppPermissionsManager {
  @override
  Future<PermissionStatus> checkPermission(Permission permission) async {
    return permission.status;
  }

  @override
  Future<PermissionStatus> requestPermission(Permission permission) async {
    return permission.request();
  }

  @override
  Future<bool> openSettings() async {
    return openAppSettings();
  }

  @override
  Future<bool> isNotificationGranted() async {
    final status = await checkPermission(Permission.notification);
    return status.isGranted;
  }

  @override
  Future<bool> isLocationGranted() async {
    final status = await checkPermission(Permission.location);
    return status.isGranted;
  }

  @override
  Future<bool> isCameraGranted() async {
    final status = await checkPermission(Permission.camera);
    return status.isGranted;
  }
}
