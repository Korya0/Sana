import 'dart:async';
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/services/sharedpref/pref_keys.dart';
import 'package:sana/core/services/sharedpref/shared_pref.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/salat_ala_Nabi/data/models/reminder_settings.dart';

abstract class IReminderRepo {
  Future<Either<Failure, ReminderSettings>> getSettings();
  Future<Either<Failure, bool>> saveSettings(ReminderSettings settings);
}

class ReminderRepoImpl implements IReminderRepo {
  ReminderRepoImpl({required this.sharedPref});
  final ISharedPref sharedPref;

  @override
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
    } catch (e, stack) {
      unawaited(
        AppLogger.error('GetSettings Error', error: e, stackTrace: stack),
      );
      return const Left(
        CacheFailure(
          message: AppStrings.ourFault,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> saveSettings(ReminderSettings settings) async {
    try {
      await sharedPref.setString(
        PrefKeys.settingsKey,
        jsonEncode(settings.toJson()),
      );
      return const Right(true);
    } catch (e, stack) {
      unawaited(
        AppLogger.error('SaveSettings Error', error: e, stackTrace: stack),
      );
      return const Left(
        CacheFailure(
          message: AppStrings.ourFault,
        ),
      );
    }
  }
}
