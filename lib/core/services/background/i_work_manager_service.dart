enum AppExistingPeriodicWorkPolicy {
  replace,
  keep,
  update,
}

enum AppNetworkType {
  notRequired,
  connected,
  unmetered,
  notRoaming,
  metered,
}

class AppWorkManagerConstraints {
  const AppWorkManagerConstraints({
    this.networkType = AppNetworkType.notRequired,
    this.requiresBatteryNotLow = false,
    this.requiresCharging = false,
    this.requiresDeviceIdle = false,
    this.requiresStorageNotLow = false,
  });

  final AppNetworkType networkType;
  final bool requiresBatteryNotLow;
  final bool requiresCharging;
  final bool requiresDeviceIdle;
  final bool requiresStorageNotLow;
}

abstract interface class IWorkManagerService {
  Future<void> initialize(Function callbackDispatcher);
  Future<void> registerPeriodicTask({
    required String uniqueName,
    required String taskName,
    Duration? frequency,
    AppExistingPeriodicWorkPolicy? existingWorkPolicy,
    AppWorkManagerConstraints? constraints,
    Map<String, dynamic>? inputData,
  });
  Future<void> cancelByUniqueName(String uniqueName);
  Future<void> cancelAll();
}

