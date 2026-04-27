import 'dart:async';

import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/networking/api_result.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/salat_ala_nabi/data/datasources/reminder_local_data_source.dart';
import 'package:sana/features/salat_ala_nabi/data/models/reminder_settings.dart';

abstract class IReminderRepository {
  Future<ApiResult<ReminderSettingsModel>> getSettings();
  Future<ApiResult<bool>> saveSettings(ReminderSettingsModel settings);
}

class ReminderRepositoryImpl implements IReminderRepository {
  ReminderRepositoryImpl({required this.localDataSource});
  final IReminderLocalDataSource localDataSource;

  @override
  Future<ApiResult<ReminderSettingsModel>> getSettings() async {
    try {
      final settings = await localDataSource.getSettings();
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
  Future<ApiResult<bool>> saveSettings(ReminderSettingsModel settings) async {
    try {
      await localDataSource.saveSettings(settings);
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
