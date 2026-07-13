import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:sana/core/routing/app_router.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/services/background/i_work_manager_service.dart';
import 'package:sana/core/services/notification/i_notification_service.dart';
import 'package:sana/core/services/notification/models/notification_payload.dart';
import 'package:sana/core/services/notification/notification_keys.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

/// Initializes heavy services after the app frame is rendered.
class HeavyServicesBootstrapper {
  HeavyServicesBootstrapper({
    required INotificationService notificationService,
    required IWorkManagerService workManagerService,
    required FirebaseRemoteConfig remoteConfig,
    required Function salawatCallbackDispatcher,
  })  : _notificationService = notificationService,
        _workManagerService = workManagerService,
        _remoteConfig = remoteConfig,
        _salawatCallbackDispatcher = salawatCallbackDispatcher;

  final INotificationService _notificationService;
  final IWorkManagerService _workManagerService;
  final FirebaseRemoteConfig _remoteConfig;
  final Function _salawatCallbackDispatcher;

  bool _initialized = false;

  /// Initializes all heavy services. Idempotent — safe to call multiple times.
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    await Future<void>.delayed(const Duration(seconds: 1));
    await _initServices();
  }

  Future<void> _initServices() async {
    try {
      if (!kIsWeb) {
        tz_data.initializeTimeZones();
        final timeZoneName = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(timeZoneName));

        await _notificationService.initialize();

        await _workManagerService.initialize(_salawatCallbackDispatcher);
      }

      // Delayed Remote Config fetch (30s delay to avoid CPU contention)
      if (Firebase.apps.isNotEmpty) {
        unawaited(
          Future<void>.delayed(const Duration(seconds: 30)).then(
            (_) => _remoteConfig
                .fetchAndActivate()
                .then((_) => AppLogger.info('Remote Config activated'))
                .catchError((e) => false),
          ),
        );
      }
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.reportToFirebase(
          'Error in post-frame initialization',
          error: e,
          stackTrace: stack,
        ),
      );
    }
  }

  bool _isNotificationTapHandlerSetup = false;

  /// Sets up the notification tap handler for navigating to azkar on tap.
  void setupNotificationTapHandler() {
    if (_isNotificationTapHandlerSetup) return;
    _isNotificationTapHandlerSetup = true;
    _notificationService.setOnNotificationTap((payload) {
      if (payload == null || payload.isEmpty) return;
      try {
        final notificationPayload = NotificationPayload.fromRawJson(payload);
        final navigatorContext = AppRouter.navigatorKey.currentContext;
        if (navigatorContext == null) return;

        switch (notificationPayload.type) {
          case NotificationKeys.typeAzkar:
            final azkarId =
                notificationPayload.data[NotificationKeys.azkarId];
            if (azkarId != null && azkarId.isNotEmpty) {
              unawaited(
                AppRouter.router.push(
                  AppRoutes.azkarList.replaceAll(
                    ':${AppRoutes.categoryIdKey}',
                    azkarId,
                  ),
                ),
              );
            }
          case NotificationKeys.typePrayer:
          case NotificationKeys.typeSalawat:
            // Future: add navigation for prayer/salawat notifications
            break;
        }
      } on Object catch (e, stack) {
        unawaited(
          AppLogger.reportToFirebase(
            'NotificationTapHandler Error',
            error: e,
            stackTrace: stack,
          ),
        );
      }
    });
  }
}
