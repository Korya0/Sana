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
    ExistingPeriodicWorkPolicy? existingWorkPolicy,
    Constraints? constraints,
    Map<String, dynamic>? inputData,
  }) async {
    await Workmanager().registerPeriodicTask(
      uniqueName,
      taskName,
      frequency: frequency,
      existingWorkPolicy:
          existingWorkPolicy ?? ExistingPeriodicWorkPolicy.replace,
      constraints: constraints,
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
}
