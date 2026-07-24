import 'package:sana/core/services/local_storage/storage_keys.dart';
import 'package:sana/core/services/local_storage/local_storage_service.dart';
import 'package:sana/features/prayer/domain/entities/user_prayer_times_settings_entity.dart';

abstract interface class UserSettingsService {
  Future<void> saveSettings(UserPrayerTimesSettings settings);
  Future<UserPrayerTimesSettings> loadSettings();
}

class UserSettingsServiceImpl implements UserSettingsService {
  UserSettingsServiceImpl(this._sharedPref);
  final LocalStorageService _sharedPref;

  @override
  Future<void> saveSettings(UserPrayerTimesSettings settings) async {
    await _sharedPref.setString(
      StorageKeys.userPrayerSettings,
      settings.toJsonString(),
    );
  }

  @override
  Future<UserPrayerTimesSettings> loadSettings() async {
    final jsonString = _sharedPref.getString(StorageKeys.userPrayerSettings);
    if (jsonString == null) return UserPrayerTimesSettings.defaultSettings();
    return UserPrayerTimesSettings.fromRawJson(jsonString);
  }
}
