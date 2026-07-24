import 'dart:async';

import 'package:sana/core/network/result.dart';
import 'package:sana/core/services/notification/notification_service.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/salat_ala_nabi/data/salawat_constants.dart';
import 'package:sana/features/salat_ala_nabi/domain/entities/reminder_settings_entity.dart';
import 'package:sana/features/salat_ala_nabi/domain/repos/reminder_repo.dart';
import 'package:sana/features/salat_ala_nabi/domain/repos/salawat_reminder_service.dart';
import 'package:sana/features/salat_ala_nabi/domain/use_cases/check_working_hours_use_case.dart';

/// Handles salawat background tasks with explicit constructor-based dependencies,
/// avoiding Service Locator anti-pattern inside background isolates.
class SalawatBackgroundTaskHandler {
  SalawatBackgroundTaskHandler({
    required ReminderRepository reminderRepository,
    required NotificationService notificationService,
    required SalawatReminderService salawatReminderService,
  })  : _reminderRepository = reminderRepository,
        _notificationService = notificationService,
        _salawatReminderService = salawatReminderService;

  final ReminderRepository _reminderRepository;
  final NotificationService _notificationService;
  final SalawatReminderService _salawatReminderService;

  /// Executes a salawat background task.
  Future<bool> execute(String task, DateTime currentTime) async {
    if (task != AppSalawatConstants.taskName) return true;

    try {
      await _notificationService.initialize();

      final settings = await _reminderRepository.getSettings();

      return switch (settings) {
        Success(data: final settingsEntity) => _handleSettings(
            settingsEntity,
            currentTime,
          ),
        FailureResult() => false,
      };
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.reportToFirebase(
          'Error in background salawat task',
          error: e,
          stackTrace: stack,
        ),
      );
      return false;
    }
  }

  Future<bool> _handleSettings(
    ReminderSettingsEntity settings,
    DateTime currentTime,
  ) async {
    if (!settings.isEnabled) return true;

    final isWithinHours = const CheckWorkingHoursUseCase().call(
      settings: settings,
      time: currentTime,
    );

    if (!isWithinHours) return true;

    await _salawatReminderService.showSalawatNotification();
    return true;
  }
}
