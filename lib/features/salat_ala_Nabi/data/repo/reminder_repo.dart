import 'dart:async';
import 'dart:convert';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/networking/api_result.dart';
import 'package:sana/core/services/local_storage/storage_keys.dart';
import 'package:sana/core/services/local_storage/local_storage_service.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/salat_ala_Nabi/data/models/reminder_settings.dart';

abstract class IReminderRepo {
  Future<ApiResult<ReminderSettings>> getSettings();
  Future<ApiResult<bool>> saveSettings(ReminderSettings settings);
}

class ReminderRepoImpl implements IReminderRepo {
  ReminderRepoImpl({required this.sharedPref});
  final ILocalStorageService sharedPref;

  @override
  Future<ApiResult<ReminderSettings>> getSettings() async {
    try {
      final jsonString = sharedPref.getString(StorageKeys.settingsKey);
      if (jsonString == null) {
        return ApiResult.success(ReminderSettings.defaultSettings());
      }
      final settings = ReminderSettings.fromJson(
        jsonDecode(jsonString) as Map<String, dynamic>,
      );
      return ApiResult.success(settings);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error('GetSettings Error', error: e, stackTrace: stack),
      );
      return const ApiResult.failure(
        Failure.cache(
          message: AppStrings.ourFault,
        ),
      );
    }
  }

  @override
  Future<ApiResult<bool>> saveSettings(ReminderSettings settings) async {
    try {
      await sharedPref.setString(
        StorageKeys.settingsKey,
        jsonEncode(settings.toJson()),
      );
      return const ApiResult.success(true);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error('SaveSettings Error', error: e, stackTrace: stack),
      );
      return const ApiResult.failure(
        Failure.cache(
          message: AppStrings.ourFault,
        ),
      );
    }
  }
}
