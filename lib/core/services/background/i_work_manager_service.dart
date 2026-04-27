import 'package:workmanager/workmanager.dart';

abstract interface class IWorkManagerService {
  Future<void> initialize(Function callbackDispatcher);
  Future<void> registerPeriodicTask({
    required String uniqueName,
    required String taskName,
    Duration? frequency,
    ExistingPeriodicWorkPolicy? existingWorkPolicy,
    Constraints? constraints,
    Map<String, dynamic>? inputData,
  });
  Future<void> cancelByUniqueName(String uniqueName);
  Future<void> cancelAll();
}
