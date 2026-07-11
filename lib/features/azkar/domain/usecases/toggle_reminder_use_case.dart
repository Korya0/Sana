import 'package:sana/core/networking/result.dart';
import 'package:sana/features/azkar/domain/repositories/reminder_repository.dart';

class ToggleReminderUseCase {
  const ToggleReminderUseCase(this._repository);

  final ReminderRepository _repository;

  Future<Result<void>> call(String id, {required bool isEnabled}) {
    return _repository.toggleReminder(id, isEnabled: isEnabled);
  }
}
