import 'package:sana/core/networking/result.dart';
import 'package:sana/core/services/notification/notification_scheduler.dart';
import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';
import 'package:sana/features/azkar/domain/params/create_reminder_params.dart';
import 'package:sana/features/azkar/domain/repositories/reminder_repository.dart';
import 'package:sana/features/azkar/domain/usecases/reminder_scheduler_helper.dart';

class CreateReminderUseCase {
  const CreateReminderUseCase(this._repository, this._scheduler);

  final ReminderRepository _repository;
  final NotificationScheduler _scheduler;

  Future<Result<void>> call(CreateReminderParams params) async {
    final reminder = ReminderEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      azkarId: params.azkarId,
      time: params.time,
      repeatType: params.repeatType,
      days: params.days,
      isEnabled: params.isEnabled,
      timezone: params.timezone,
      template: params.template,
    );
    final result = await _repository.createReminder(reminder);
    if (result is Success<void>) {
      if (reminder.isEnabled) {
        await ReminderSchedulerHelper.scheduleAll(reminder, _scheduler);
      }
    }
    return result;
  }
}
