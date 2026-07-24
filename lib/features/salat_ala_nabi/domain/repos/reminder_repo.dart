import 'package:sana/core/network/result.dart';
import 'package:sana/features/salat_ala_nabi/domain/entities/reminder_settings_entity.dart';

abstract interface class ReminderRepository {
  Future<Result<ReminderSettingsEntity>> getSettings();
  Future<Result<bool>> saveSettings(ReminderSettingsEntity settings);
}
