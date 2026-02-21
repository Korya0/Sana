import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  static void info(String message) {
    if (kDebugMode) _logger.i(message);
  }

  static void warn(String message) {
    if (kDebugMode) _logger.w(message);
  }

  static void error(String message) {
    if (kDebugMode) _logger.e(message);
  }

  static void debug(String message) {
    if (kDebugMode) _logger.d(message);
  }
}
