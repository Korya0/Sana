import 'package:flutter/foundation.dart';

class AppLogger {
  const AppLogger();

  void debug(String message) {
    _log('DEBUG', message);
  }

  void info(String message) {
    _log('INFO', message);
  }

  void success(String message) {
    _log('SUCCESS', message);
  }

  void warning(String message) {
    _log('WARNING', message);
  }

  void error(String message, {Object? error, StackTrace? stackTrace}) {
    _log('ERROR', message, error: error, stackTrace: stackTrace);
  }

  void _log(
    String level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode) return;

    debugPrint('[$level] $message');

    if (error != null) debugPrint('Error: $error');
    if (stackTrace != null) debugPrint('StackTrace: $stackTrace');
  }
}
