import 'package:sana/core/networking/result.dart';
import 'package:sana/features/salat_ala_nabi/domain/entities/reminder_settings_entity.dart';

abstract interface class IReminderRepository {
  Future<Result<ReminderSettingsEntity>> getSettings();
  Future<Result<bool>> saveSettings(ReminderSettingsEntity settings);
}
