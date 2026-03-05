import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  static void info(String message) {
    if (kDebugMode) _logger.i(message);
  }

  static void warn(String message) {
    if (kDebugMode) _logger.w(message);
  }

  static void debug(String message) {
    if (kDebugMode) _logger.d(message);
  }

  static Future<void> error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) async {
    if (kDebugMode) {
      _logger.e(
        message,
        error: error,
        stackTrace: stackTrace,
      );
    } else if (!kIsWeb) {
      // In release mode, send the error to Crashlytics
      await FirebaseCrashlytics.instance.recordError(
        error ?? message,
        stackTrace,
        reason: message,
      );
    }
  }

  static void success(String message) {
    if (kDebugMode) _logger.i('✅ SUCCESS: $message');
  }
}
