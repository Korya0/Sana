import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:sana/core/services/local_storage/i_local_storage_service.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/azkar/domain/repositories/reminder_repository.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

/// Monitors app lifecycle for timezone/clock changes and reschedules reminders.
class LifecycleManager {
  LifecycleManager({
    required ILocalStorageService localStorageService,
    required IReminderRepository reminderRepository,
  })  : _localStorageService = localStorageService,
        _reminderRepository = reminderRepository;

  final ILocalStorageService _localStorageService;
  final IReminderRepository _reminderRepository;

  String? _storedTimezone;

  /// Starts listening to app lifecycle events.
  void start() {
    WidgetsBinding.instance.addObserver(_AppLifecycleObserver(this));
  }

  Future<void> _onAppResumed() async {
    try {
      final currentTimezone = await FlutterTimezone.getLocalTimezone();
      if (currentTimezone != _storedTimezone) {
        // Timezone changed — reschedule all reminders
        tz.setLocalLocation(tz.getLocation(currentTimezone));
        await _reminderRepository.rescheduleAllActiveReminders();
        _storedTimezone = currentTimezone;
        await _storeTimezone(currentTimezone);
      }
    } on Object catch (e, stackTrace) {
      unawaited(
        AppLogger.warn(
          'Lifecycle resume reminder refresh error',
          error: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Stores the current timezone after first initialization.
  Future<void> storeCurrentTimezone() async {
    try {
      final timezone = await FlutterTimezone.getLocalTimezone();
      _storedTimezone = timezone;
      await _storeTimezone(timezone);
    } on Object catch (e, stackTrace) {
      unawaited(
        AppLogger.error(
          'Failed to store timezone',
          error: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  Future<void> _storeTimezone(String timezone) async {
    try {
      await _localStorageService.setString('stored_timezone', timezone);
    } on Object catch (e, stackTrace) {
      unawaited(
        AppLogger.error(
          'Failed to store timezone',
          error: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}

class _AppLifecycleObserver with WidgetsBindingObserver {
  _AppLifecycleObserver(this._manager);

  final LifecycleManager _manager;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_manager._onAppResumed());
    }
  }
}
