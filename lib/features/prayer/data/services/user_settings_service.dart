import 'package:adhan/adhan.dart';
import 'package:sana/core/services/sharedpref/pref_keys.dart';
import 'package:sana/core/services/sharedpref/shared_pref.dart';
import 'package:sana/features/prayer/data/models/user_prayer_times_settings.dart';

class UserSettingsService {
  UserSettingsService(this._sharedPref);
  final ISharedPref _sharedPref;

  Future<void> saveSettings(UserPrayerTimesSettings settings) async {
    await _sharedPref.setString(PrefKeys.userPrayerSettings, settings.toJson());
  }

  Future<UserPrayerTimesSettings> loadSettings() async {
    final jsonString = _sharedPref.getString(PrefKeys.userPrayerSettings);
    if (jsonString == null) return UserPrayerTimesSettings.defaultSettings();
    return UserPrayerTimesSettings.fromJson(jsonString);
  }

  /// Converts stored settings to Adhan library parameters.
  Future<CalculationParameters> getCalculationParameters() async {
    final settings = await loadSettings();
    return settings.method.getParameters()
      ..madhab = settings.madhab
      ..adjustments = settings.adjustments;
  }
}
