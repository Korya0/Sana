import 'package:sana/features/azkar/data/models/reminder_model.dart';
import 'package:sana/features/azkar/domain/entities/notification_template.dart';
import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';
import 'package:sana/features/azkar/domain/entities/repeat_type.dart';

class ReminderMapper {
  const ReminderMapper._();

  static ReminderEntity toEntity(ReminderModel model) {
    return ReminderEntity(
      id: model.id,
      azkarId: model.azkarId,
      time: model.time,
      repeatType: RepeatType.values.firstWhere(
        (type) => type.name == model.repeatType,
        orElse: () => RepeatType.once,
      ),
      days: model.days,
      isEnabled: model.isEnabled,
      timezone: model.timezone,
      template: NotificationTemplate.fromAzkarId(model.template),
    );
  }

  static ReminderModel toModel(ReminderEntity entity) {
    return ReminderModel(
      id: entity.id,
      azkarId: entity.azkarId,
      time: entity.time,
      repeatType: entity.repeatType.name,
      days: entity.days,
      isEnabled: entity.isEnabled,
      timezone: entity.timezone,
      template: entity.template.name,
    );
  }
}
