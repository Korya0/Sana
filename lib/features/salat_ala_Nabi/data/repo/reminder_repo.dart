import 'dart:convert';
import 'package:sana/core/services/sharedpref/pref_keys.dart';
import 'package:sana/core/services/sharedpref/shared_pref.dart';
import 'package:sana/features/salat_ala_Nabi/data/models/reminder_settings.dart';

class ReminderRepo {
  final SharedPref sharedPref;

  ReminderRepo({required this.sharedPref});

  /// Get reminder settings
  Future<ReminderSettings> getSettings() async {
    try {
      final jsonString = sharedPref.getString(PrefKeys.settingsKey);
      if (jsonString == null) {
        return ReminderSettings.defaultSettings();
      }
      return ReminderSettings.fromJson(
        jsonDecode(jsonString) as Map<String, dynamic>,
      );
    } catch (e) {
      return ReminderSettings.defaultSettings();
    }
  }

  /// Save reminder settings
  Future<void> saveSettings(ReminderSettings settings) async {
    await sharedPref.setString(
      PrefKeys.settingsKey,
      jsonEncode(settings.toJson()),
    );
  }
}
