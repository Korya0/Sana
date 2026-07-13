import 'package:sana/core/services/local_storage/storage_keys.dart';
import 'package:sana/core/services/local_storage/i_local_storage_service.dart';
import 'package:sana/features/prayer/domain/entities/user_prayer_times_settings_entity.dart';

abstract interface class IUserSettingsService {
  Future<void> saveSettings(UserPrayerTimesSettings settings);
  Future<UserPrayerTimesSettings> loadSettings();
}

class UserSettingsServiceImpl implements IUserSettingsService {
  UserSettingsServiceImpl(this._sharedPref);
  final ILocalStorageService _sharedPref;

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
