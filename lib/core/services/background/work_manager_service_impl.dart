import 'package:sana/core/services/background/i_work_manager_service.dart';
import 'package:workmanager/workmanager.dart';

class WorkManagerServiceImpl implements IWorkManagerService {
  @override
  Future<void> initialize(Function callbackDispatcher) async {
    await Workmanager().initialize(callbackDispatcher);
  }

  @override
  Future<void> registerPeriodicTask({
    required String uniqueName,
    required String taskName,
    Duration? frequency,
    AppExistingPeriodicWorkPolicy? existingWorkPolicy,
    AppWorkManagerConstraints? constraints,
    Map<String, dynamic>? inputData,
  }) async {
    await Workmanager().registerPeriodicTask(
      uniqueName,
      taskName,
      frequency: frequency,
      existingWorkPolicy: _mapExistingPeriodicWorkPolicy(existingWorkPolicy),
      constraints: _mapConstraints(constraints),
      inputData: inputData,
    );
  }

  @override
  Future<void> cancelByUniqueName(String uniqueName) async {
    await Workmanager().cancelByUniqueName(uniqueName);
  }

  @override
  Future<void> cancelAll() async {
    await Workmanager().cancelAll();
  }

  ExistingPeriodicWorkPolicy _mapExistingPeriodicWorkPolicy(
    AppExistingPeriodicWorkPolicy? policy,
  ) {
    if (policy == null) return ExistingPeriodicWorkPolicy.replace;
    return switch (policy) {
      AppExistingPeriodicWorkPolicy.replace =>
        ExistingPeriodicWorkPolicy.replace,
      AppExistingPeriodicWorkPolicy.keep => ExistingPeriodicWorkPolicy.keep,
      AppExistingPeriodicWorkPolicy.update => ExistingPeriodicWorkPolicy.update,
    };
  }

  Constraints? _mapConstraints(AppWorkManagerConstraints? constraints) {
    if (constraints == null) return null;
    return Constraints(
      networkType: _mapNetworkType(constraints.networkType),
      requiresBatteryNotLow: constraints.requiresBatteryNotLow,
      requiresCharging: constraints.requiresCharging,
      requiresDeviceIdle: constraints.requiresDeviceIdle,
      requiresStorageNotLow: constraints.requiresStorageNotLow,
    );
  }

  NetworkType _mapNetworkType(AppNetworkType networkType) {
    return switch (networkType) {
      AppNetworkType.notRequired => NetworkType.notRequired,
      AppNetworkType.connected => NetworkType.connected,
      AppNetworkType.unmetered => NetworkType.unmetered,
      AppNetworkType.notRoaming => NetworkType.notRoaming,
      AppNetworkType.metered => NetworkType.metered,
    };
  }
}
