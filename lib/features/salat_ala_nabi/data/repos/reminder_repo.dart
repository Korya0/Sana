import 'dart:async';

import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/error/error.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/salat_ala_nabi/data/datasources/reminder_local_data_source.dart';
import 'package:sana/features/salat_ala_nabi/data/models/reminder_settings.dart';

abstract class IReminderRepository {
  Future<Result<ReminderSettingsModel>> getSettings();
  Future<Result<bool>> saveSettings(ReminderSettingsModel settings);
}

class ReminderRepositoryImpl implements IReminderRepository {
  ReminderRepositoryImpl({required this.localDataSource});
  final IReminderLocalDataSource localDataSource;

  @override
  Future<Result<ReminderSettingsModel>> getSettings() async {
    try {
      final settings = await localDataSource.getSettings();
      return Result.success(settings);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error('GetSettings Error', error: e, stackTrace: stack),
      );
      return const Result.failure(
        CacheFailure(
          message: AppStrings.ourFault,
        ),
      );
    }
  }

  @override
  Future<Result<bool>> saveSettings(ReminderSettingsModel settings) async {
    try {
      await localDataSource.saveSettings(settings);
      return const Result.success(true);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error('SaveSettings Error', error: e, stackTrace: stack),
      );
      return const Result.failure(
        CacheFailure(
          message: AppStrings.ourFault,
        ),
      );
    }
  }
}
