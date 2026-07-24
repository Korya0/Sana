import 'dart:async';

import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/error/error.dart';
import 'package:sana/core/network/result.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/salat_ala_nabi/data/data_sources/reminder_local_data_source.dart';
import 'package:sana/features/salat_ala_nabi/data/models/reminder_settings.dart';
import 'package:sana/features/salat_ala_nabi/domain/entities/reminder_settings_entity.dart';
import 'package:sana/features/salat_ala_nabi/domain/repos/reminder_repo.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  ReminderRepositoryImpl({required this.localDataSource});
  final ReminderLocalDataSource localDataSource;

  @override
  Future<Result<ReminderSettingsEntity>> getSettings() async {
    try {
      final settings = await localDataSource.getSettings();
      return Result.success(settings);
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.localError('GetSettings Error', error: e, stackTrace: stack),
      );
      return const Result.failure(
        CacheFailure(
          message: AppStrings.ourFault,
        ),
      );
    }
  }

  @override
  Future<Result<bool>> saveSettings(ReminderSettingsEntity settings) async {
    try {
      final settingsModel = settings is ReminderSettingsModel
          ? settings
          : ReminderSettingsModel.fromEntity(settings);

      await localDataSource.saveSettings(settingsModel);
      return const Result.success(true);
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.localError('SaveSettings Error', error: e, stackTrace: stack),
      );
      return const Result.failure(
        CacheFailure(
          message: AppStrings.ourFault,
        ),
      );
    }
  }
}
