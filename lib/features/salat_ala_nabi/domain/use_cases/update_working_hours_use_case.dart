import 'package:sana/features/salat_ala_nabi/data/salawat_constants.dart';
import 'package:sana/features/salat_ala_nabi/domain/entities/reminder_settings_entity.dart';

class UpdateWorkingHoursUseCase {
  const UpdateWorkingHoursUseCase();

  ReminderSettingsEntity call({
    required ReminderSettingsEntity settings,
    required int mode,
  }) {
    switch (mode) {
      case WorkingHoursMode.allDay:
        return ReminderSettingsEntity(
          isEnabled: settings.isEnabled,
          intervalMinutes: settings.intervalMinutes,
          startHour: 0,
          startMinute: 0,
          endHour: 23,
          endMinute: 59,
          workingHoursMode: mode,
        );
      case WorkingHoursMode.defaultHours:
        return ReminderSettingsEntity(
          isEnabled: settings.isEnabled,
          intervalMinutes: settings.intervalMinutes,
          startHour: AppSalawatConstants.defaultStartHour,
          startMinute: 0,
          endHour: AppSalawatConstants.defaultEndHour,
          endMinute: 0,
          workingHoursMode: mode,
        );
      case WorkingHoursMode.custom:
      default:
        return ReminderSettingsEntity(
          isEnabled: settings.isEnabled,
          intervalMinutes: settings.intervalMinutes,
          startHour: settings.startHour,
          startMinute: settings.startMinute,
          endHour: settings.endHour,
          endMinute: settings.endMinute,
          workingHoursMode: mode,
        );
    }
  }
}
