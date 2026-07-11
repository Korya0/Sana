import 'package:sana/core/networking/result.dart';
import 'package:sana/features/azkar/domain/repositories/reminder_repository.dart';

class DeleteReminderUseCase {
  const DeleteReminderUseCase(this._repository);

  final ReminderRepository _repository;

  Future<Result<void>> call(String id) {
    return _repository.deleteReminder(id);
  }
}
