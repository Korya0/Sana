import 'package:sana/core/networking/result.dart';
import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';
import 'package:sana/features/azkar/domain/params/create_reminder_params.dart';
import 'package:sana/features/azkar/domain/repositories/reminder_repository.dart';

class CreateReminderUseCase {
  const CreateReminderUseCase(this._repository);

  final ReminderRepository _repository;

  Future<Result<void>> call(CreateReminderParams params) {
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
    return _repository.createReminder(reminder);
  }
}
