import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/services/sharedpref/pref_keys.dart';
import 'package:sana/core/services/sharedpref/shared_pref.dart';
import 'package:sana/features/salat_ala_Nabi/data/models/reminder_settings.dart';

class ReminderRepo {
  ReminderRepo({required this.sharedPref});
  final SharedPref sharedPref;

  /// Get reminder settings
  Future<Either<Failure, ReminderSettings>> getSettings() async {
    try {
      final jsonString = sharedPref.getString(PrefKeys.settingsKey);
      if (jsonString == null) {
        return Right(ReminderSettings.defaultSettings());
      }
      final settings = ReminderSettings.fromJson(
        jsonDecode(jsonString) as Map<String, dynamic>,
      );
      return Right(settings);
    } catch (e) {
      return const Left(
        CacheFailure(
          message: AppStrings.cacheError,
        ),
      );
    }
  }

  /// Save reminder settings
  Future<Either<Failure, bool>> saveSettings(ReminderSettings settings) async {
    try {
      await sharedPref.setString(
        PrefKeys.settingsKey,
        jsonEncode(settings.toJson()),
      );
      return const Right(true);
    } catch (e) {
      return const Left(
        CacheFailure(
          message: AppStrings.cacheError,
        ),
      );
    }
  }
}
