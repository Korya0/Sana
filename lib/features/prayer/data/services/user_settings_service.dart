import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_prayer_times_settings.dart';

class UserSettingsService {
  static const _keySettings = 'user_prayer_settings';

  Future<void> saveSettings(UserPrayerTimesSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySettings, settings.toJson());
  }

  Future<UserPrayerTimesSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keySettings);
    if (jsonString == null) return UserPrayerTimesSettings.defaultSettings();
    return UserPrayerTimesSettings.fromJson(jsonString);
  }
}
