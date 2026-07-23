import 'package:sana/core/network/result.dart';
import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';
import 'package:sana/features/azkar/domain/repositories/reminder_repository.dart';

class GetRemindersUseCase {
  const GetRemindersUseCase(this._repository);

  final IReminderRepository _repository;

  Future<Result<List<ReminderEntity>>> call(String azkarId) {
    return _repository.getReminders(azkarId);
  }
}
