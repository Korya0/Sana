import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/core/services/notification/models/notification_payload.dart';
import 'package:sana/core/services/notification/models/notification_request.dart';
import 'package:sana/core/services/notification/notification_keys.dart';
import 'package:sana/core/services/notification/notification_scheduler.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/azkar/data/datasources/reminder_local_data_source.dart';
import 'package:sana/features/azkar/data/mappers/reminder_mapper.dart';
import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';
import 'package:sana/features/azkar/domain/entities/repeat_type.dart';
import 'package:sana/features/azkar/domain/repositories/reminder_repository.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  const ReminderRepositoryImpl(this._dataSource, this._scheduler);

  final ReminderLocalDataSource _dataSource;
  final NotificationScheduler _scheduler;

  @override
  Future<Result<List<ReminderEntity>>> getReminders(String azkarId) async {
    try {
      final models = await _dataSource.getReminders(azkarId);
      return Result.success(models.map(ReminderMapper.toEntity).toList());
    } on Exception catch (e, stack) {
      await AppLogger.error(
        'ReminderRepositoryImpl.getReminders',
        error: e,
        stackTrace: stack,
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
      if (reminder.isEnabled) {
        await _scheduleAll(reminder);
      }
      return const Result.success(null);
    } on Exception catch (e, stack) {
      await AppLogger.error(
        'ReminderRepositoryImpl.createReminder',
        error: e,
        stackTrace: stack,
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
      await _cancelAll(reminder.id);
      if (reminder.isEnabled) {
        await _scheduleAll(reminder);
      }
      return const Result.success(null);
    } on Exception catch (e, stack) {
      await AppLogger.error(
        'ReminderRepositoryImpl.updateReminder',
        error: e,
        stackTrace: stack,
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
      await _cancelAll(id);
      return const Result.success(null);
    } on Exception catch (e, stack) {
      await AppLogger.error(
        'ReminderRepositoryImpl.deleteReminder',
        error: e,
        stackTrace: stack,
      );
      return const Result.failure(
        ReminderFailure(message: AppStrings.reminderDeleteError),
      );
    }
  }

  @override
  Future<Result<void>> toggleReminder(
    String id, {
    required bool isEnabled,
  }) async {
    try {
      final models = await _dataSource.getReminders('');
      final model = models.where((m) => m.id == id).firstOrNull;
      if (model == null) {
        return const Result.failure(
          ReminderFailure(message: AppStrings.reminderNotFound),
        );
      }
      final updated =
          ReminderMapper.toEntity(model).copyWith(isEnabled: isEnabled);
      await _dataSource.saveReminder(ReminderMapper.toModel(updated));
      await _cancelAll(id);
      if (isEnabled) {
        await _scheduleAll(updated);
      }
      return const Result.success(null);
    } on Exception catch (e, stack) {
      await AppLogger.error(
        'ReminderRepositoryImpl.toggleReminder',
        error: e,
        stackTrace: stack,
      );
      return const Result.failure(
        ReminderFailure(message: AppStrings.reminderToggleError),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  /// Schedules one notification per effective day.
  Future<void> _scheduleAll(ReminderEntity reminder) async {
    final parts = reminder.time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    final effectiveDays = reminder.repeatType == RepeatType.daily
        ? List.generate(7, (i) => i + 1)
        : reminder.repeatType == RepeatType.once
            ? <int>[]
            : reminder.days;

    final payload = NotificationPayload(
      id: reminder.id,
      type: NotificationKeys.typeAzkar,
      data: {NotificationKeys.azkarId: reminder.azkarId},
    );

    if (effectiveDays.isEmpty) {
      // Once: schedule for today/tomorrow at given time
      final now = DateTime.now();
      var scheduled =
          DateTime(now.year, now.month, now.day, hour, minute);
      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }
      await _scheduler.schedule(
        NotificationRequest(
          id: reminder.id.hashCode,
          title: reminder.template.title,
          body: reminder.template.body,
          scheduledDateTime: scheduled,
          payload: payload,
        ),
      );
    } else {
      // Daily or custom days: one notification per weekday
      for (final day in effectiveDays) {
        final now = DateTime.now();
        var scheduled =
            DateTime(now.year, now.month, now.day, hour, minute);
        // Advance to the next matching weekday
        while (scheduled.weekday != day || scheduled.isBefore(now)) {
          scheduled = scheduled.add(const Duration(days: 1));
        }
        await _scheduler.schedule(
          NotificationRequest(
            id: _dayNotificationId(reminder.id, day),
            title: reminder.template.title,
            body: reminder.template.body,
            scheduledDateTime: scheduled,
            payload: payload,
            repeats: true,
            weekdays: [day],
          ),
        );
      }
    }
  }

  Future<void> _cancelAll(String reminderId) async {
    // Cancel once notification
    await _scheduler.cancel(reminderId.hashCode);
    // Cancel per-day notifications (days 1–7)
    for (var day = 1; day <= 7; day++) {
      await _scheduler.cancel(_dayNotificationId(reminderId, day));
    }
  }

  int _dayNotificationId(String reminderId, int day) =>
      '${reminderId}_$day'.hashCode;
}
