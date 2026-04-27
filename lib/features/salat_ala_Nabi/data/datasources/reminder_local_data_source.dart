import 'dart:convert';

import 'package:sana/core/services/local_storage/local_storage_service.dart';
import 'package:sana/core/services/local_storage/storage_keys.dart';
import 'package:sana/features/salat_ala_nabi/data/models/reminder_settings.dart';

abstract class IReminderLocalDataSource {
  Future<ReminderSettingsModel> getSettings();
  Future<void> saveSettings(ReminderSettingsModel settings);
}

class ReminderLocalDataSourceImpl implements IReminderLocalDataSource {
  ReminderLocalDataSourceImpl(this._storageService);
  final ILocalStorageService _storageService;

  @override
  Future<ReminderSettingsModel> getSettings() async {
    final jsonString = _storageService.getString(StorageKeys.settingsKey);
    if (jsonString == null) {
      return ReminderSettingsModel.defaultSettings();
    }
    return ReminderSettingsModel.fromJson(
      jsonDecode(jsonString) as Map<String, dynamic>,
    );
  }

  @override
  Future<void> saveSettings(ReminderSettingsModel settings) async {
    await _storageService.setString(
      StorageKeys.settingsKey,
      jsonEncode(settings.toJson()),
    );
  }
}
