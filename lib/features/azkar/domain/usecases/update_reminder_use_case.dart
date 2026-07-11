import 'package:sana/core/networking/result.dart';
import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';
import 'package:sana/features/azkar/domain/repositories/reminder_repository.dart';

class UpdateReminderUseCase {
  const UpdateReminderUseCase(this._repository);

  final ReminderRepository _repository;

  Future<Result<void>> call(ReminderEntity reminder) {
    return _repository.updateReminder(reminder);
  }
}
