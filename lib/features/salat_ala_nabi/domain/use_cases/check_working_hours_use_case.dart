import 'package:sana/features/salat_ala_nabi/domain/entities/reminder_settings_entity.dart';

class CheckWorkingHoursUseCase {
  const CheckWorkingHoursUseCase();

  bool call({
    required ReminderSettingsEntity settings,
    required DateTime time,
  }) {
    final currentInMinutes = time.hour * 60 + time.minute;
    final startInMinutes = settings.startHour * 60 + settings.startMinute;
    final endInMinutes = settings.endHour * 60 + settings.endMinute;

    if (startInMinutes <= endInMinutes) {
      return currentInMinutes >= startInMinutes &&
          currentInMinutes <= endInMinutes;
    } else {
      // Case where the range crosses midnight (e.g., 22:00 to 02:00)
      return currentInMinutes >= startInMinutes ||
          currentInMinutes <= endInMinutes;
    }
  }
}
