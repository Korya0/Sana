import 'dart:async';

import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/azkar/data/datasources/reminder_local_data_source.dart';
import 'package:sana/features/azkar/data/mappers/reminder_mapper.dart';
import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';
import 'package:sana/features/azkar/domain/repositories/reminder_repository.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  const ReminderRepositoryImpl(this._dataSource);

  final ReminderLocalDataSource _dataSource;

  @override
  Future<Result<List<ReminderEntity>>> getReminders(String azkarId) async {
    try {
      final models = await _dataSource.getReminders(azkarId);
      return Result.success(models.map(ReminderMapper.toEntity).toList());
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.error(
          'ReminderRepositoryImpl.getReminders',
          error: e,
          stackTrace: stack,
        ),
      );
      return const Result.failure(
        ReminderFailure(message: AppStrings.reminderLoadError),
      );
    }
  }

  @override
  Future<Result<List<ReminderEntity>>> getAllReminders() async {
    try {
      final models = await _dataSource.getAllReminders();
      return Result.success(models.map(ReminderMapper.toEntity).toList());
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.error(
          'ReminderRepositoryImpl.getAllReminders',
          error: e,
          stackTrace: stack,
        ),
      );
      return const Result.failure(
        ReminderFailure(message: AppStrings.reminderLoadError),
      );
    }
  }

  @override
  Future<Result<void>> createReminder(ReminderEntity reminder) async {
    try {
      await _dataSource.saveReminder(ReminderMapper.toModel(reminder));
      return const Result.success(null);
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.error(
          'ReminderRepositoryImpl.createReminder',
          error: e,
          stackTrace: stack,
        ),
      );
      return const Result.failure(
        ReminderFailure(message: AppStrings.reminderSaveError),
      );
    }
  }

  @override
  Future<Result<void>> updateReminder(ReminderEntity reminder) async {
    try {
      await _dataSource.saveReminder(ReminderMapper.toModel(reminder));
      return const Result.success(null);
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.error(
          'ReminderRepositoryImpl.updateReminder',
          error: e,
          stackTrace: stack,
        ),
      );
      return const Result.failure(
        ReminderFailure(message: AppStrings.reminderUpdateError),
      );
    }
  }

  @override
  Future<Result<void>> deleteReminder(String id) async {
    try {
      await _dataSource.deleteReminder(id);
      return const Result.success(null);
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.error(
          'ReminderRepositoryImpl.deleteReminder',
          error: e,
          stackTrace: stack,
        ),
      );
      return const Result.failure(
        ReminderFailure(message: AppStrings.reminderDeleteError),
      );
    }
  }

  @override
  Future<void> rescheduleAllActiveReminders() async {
    // This is now handled by the boot receiver/startup logic calling a use case,
    // OR we should remove this from the repository and have a dedicated UseCase.
    // For now, this is left empty since it's an orchestration concern.
  }

  @override
  Future<Result<ReminderEntity>> toggleReminder(
    String id, {
    required bool isEnabled,
  }) async {
    try {
      final models = await _dataSource.getAllReminders();
      final model = models.where((m) => m.id == id).firstOrNull;
      if (model == null) {
        return const Result.failure(
          ReminderFailure(message: AppStrings.reminderNotFound),
        );
      }
      final updated =
          ReminderMapper.toEntity(model).copyWith(isEnabled: isEnabled);
      await _dataSource.saveReminder(ReminderMapper.toModel(updated));
      return Result.success(updated);
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.error(
          'ReminderRepositoryImpl.toggleReminder',
          error: e,
          stackTrace: stack,
        ),
      );
      return const Result.failure(
        ReminderFailure(message: AppStrings.reminderToggleError),
      );
    }
  }
}

