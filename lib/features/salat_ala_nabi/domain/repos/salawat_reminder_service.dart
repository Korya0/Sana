import 'package:sana/features/salat_ala_nabi/domain/entities/reminder_settings_entity.dart';

abstract interface class SalawatReminderService {
  Future<void> scheduleReminders(ReminderSettingsEntity settings);
  Future<void> cancelReminders();
  Future<void> showConfirmation();
  Future<void> showSalawatNotification();
}
