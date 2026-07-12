import 'package:sana/core/networking/result.dart';
import 'package:sana/core/services/notification/notification_scheduler.dart';
import 'package:sana/features/azkar/domain/repositories/reminder_repository.dart';
import 'package:sana/features/azkar/domain/usecases/reminder_scheduler_helper.dart';

class DeleteReminderUseCase {
  const DeleteReminderUseCase(this._repository, this._scheduler);

  final ReminderRepository _repository;
  final NotificationScheduler _scheduler;

  Future<Result<void>> call(String id) async {
    final result = await _repository.deleteReminder(id);
    if (result is Success<void>) {
      await ReminderSchedulerHelper.cancelAll(id, _scheduler);
    }
    return result;
  }
}
