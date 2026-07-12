import 'package:sana/core/networking/result.dart';
import 'package:sana/core/services/notification/notification_scheduler.dart';
import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';
import 'package:sana/features/azkar/domain/repositories/reminder_repository.dart';
import 'package:sana/features/azkar/domain/usecases/reminder_scheduler_helper.dart';

class UpdateReminderUseCase {
  const UpdateReminderUseCase(this._repository, this._scheduler);

  final ReminderRepository _repository;
  final NotificationScheduler _scheduler;

  Future<Result<void>> call(ReminderEntity reminder) async {
    final result = await _repository.updateReminder(reminder);
    if (result is Success<void>) {
      await ReminderSchedulerHelper.cancelAll(reminder.id, _scheduler);
      if (reminder.isEnabled) {
        await ReminderSchedulerHelper.scheduleAll(reminder, _scheduler);
      }
    }
    return result;
  }
}
