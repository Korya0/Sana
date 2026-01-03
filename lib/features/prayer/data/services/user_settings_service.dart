import 'package:sana/core/services/sharedpref/pref_keys.dart';
import 'package:sana/features/prayer/data/models/user_prayer_times_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettingsService {
  Future<void> saveSettings(UserPrayerTimesSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(PrefKeys.userPrayerSettings, settings.toJson());
  }

  Future<UserPrayerTimesSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(PrefKeys.userPrayerSettings);
    if (jsonString == null) return UserPrayerTimesSettings.defaultSettings();
    return UserPrayerTimesSettings.fromJson(jsonString);
  }
}
