import 'package:sana/core/networking/result.dart';
import 'package:sana/core/services/notification/notification_scheduler.dart';
import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';
import 'package:sana/features/azkar/domain/repositories/reminder_repository.dart';
import 'package:sana/features/azkar/domain/usecases/reminder_scheduler_helper.dart';

class ToggleReminderUseCase {
  const ToggleReminderUseCase(this._repository, this._scheduler);

  final ReminderRepository _repository;
  final NotificationScheduler _scheduler;

  Future<Result<void>> call(String id, {required bool isEnabled}) async {
    final result = await _repository.toggleReminder(id, isEnabled: isEnabled);
    if (result is Success<ReminderEntity>) {
      final reminder = result.data;
      await ReminderSchedulerHelper.cancelAll(id, _scheduler);
      if (isEnabled) {
        await ReminderSchedulerHelper.scheduleAll(reminder, _scheduler);
      }
      return const Result.success(null);
    } else {
      return Result.failure((result as FailureResult).failure);
    }
  }
}
