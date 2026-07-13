import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:sana/core/utils/app_logger.dart';

/// Sets up global error handlers for Flutter and the platform.
class AppErrorHandler {
  const AppErrorHandler();

  /// Configures Flutter and PlatformDispatcher error handlers
  /// to forward errors to Crashlytics in release mode and log them locally.
  void setup() {
    if (!kIsWeb) {
      FlutterError.onError = (details) {
        if (kReleaseMode && Firebase.apps.isNotEmpty) {
          unawaited(
            FirebaseCrashlytics.instance.recordFlutterFatalError(details),
          );
        }
        FlutterError.presentError(details);
        unawaited(
          AppLogger.localError(
            '[FlutterError]',
            error: details.exception,
            stackTrace: details.stack,
          ),
        );
      };

      PlatformDispatcher.instance.onError = (error, stack) {
        if (kReleaseMode && Firebase.apps.isNotEmpty) {
          unawaited(
            FirebaseCrashlytics.instance.recordError(error, stack, fatal: true),
          );
        }
        unawaited(
          AppLogger.localError(
            '[PlatformError]',
            error: error,
            stackTrace: stack,
          ),
        );
        return true;
      };
    } else {
      FlutterError.onError = (details) {
        FlutterError.presentError(details);
        unawaited(
          AppLogger.localError(
            '[FlutterError]',
            error: details.exception,
            stackTrace: details.stack,
          ),
        );
      };
    }
  }
}
