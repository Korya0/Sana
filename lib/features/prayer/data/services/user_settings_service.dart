import 'package:adhan/adhan.dart';
import 'package:sana/core/services/local_storage/storage_keys.dart';
import 'package:sana/core/services/local_storage/local_storage_service.dart';
import 'package:sana/features/prayer/data/models/user_prayer_times_settings.dart';

class UserSettingsService {
  UserSettingsService(this._sharedPref);
  final ILocalStorageService _sharedPref;

  Future<void> saveSettings(UserPrayerTimesSettings settings) async {
    await _sharedPref.setString(
      StorageKeys.userPrayerSettings,
      settings.toJsonString(),
    );
  }

  Future<UserPrayerTimesSettings> loadSettings() async {
    final jsonString = _sharedPref.getString(StorageKeys.userPrayerSettings);
    if (jsonString == null) return UserPrayerTimesSettings.defaultSettings();
    return UserPrayerTimesSettings.fromRawJson(jsonString);
  }

  /// Converts stored settings to Adhan library parameters.
  Future<CalculationParameters> getCalculationParameters() async {
    final settings = await loadSettings();
    return settings.method.getParameters()
      ..madhab = settings.madhab
      ..adjustments = settings.adjustments;
  }
}
