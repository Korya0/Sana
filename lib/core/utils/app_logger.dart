import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
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

  static Future<void> warn(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) async {
    if (kDebugMode) {
      _logger.w(
        message,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  static void debug(String message) {
    if (kDebugMode) _logger.d(message);
  }

  static final Set<int> _reportedErrorHashes = {};

  static Future<void> reportToFirebase(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) async {
    if (kDebugMode) {
      _logger.e(
        '🔥 TO FIREBASE: $message',
        error: error,
        stackTrace: stackTrace,
      );
    } else if (!kIsWeb && Firebase.apps.isNotEmpty) {
      // Filter out benign network errors to avoid spamming Crashlytics
      if (_shouldIgnoreError(error)) return;

      final errorHash = error?.hashCode ?? message.hashCode;
      if (_reportedErrorHashes.contains(errorHash)) return;
      _reportedErrorHashes.add(errorHash);
      if (_reportedErrorHashes.length > 100) _reportedErrorHashes.clear();

      // In release mode, send the error to Crashlytics
      await FirebaseCrashlytics.instance.recordError(
        error ?? message,
        stackTrace,
        reason: message,
      );
    }
  }

  static Future<void> error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    bool report = false,
  }) async {
    if (report) {
      await reportToFirebase(message, error: error, stackTrace: stackTrace);
    } else {
      await localError(message, error: error, stackTrace: stackTrace);
    }
  }

  static Future<void> localError(
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
    }
  }

  /// Checks if the error is a benign network issue that doesn't need to be reported as a bug.
  static bool _shouldIgnoreError(Object? error) {
    if (error == null) return false;

    if (error is DioException) {
      return [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
        DioExceptionType.connectionError,
        DioExceptionType.cancel,
      ].contains(error.type);
    }

    final errorString = error.toString();
    if (errorString.contains('SocketException') ||
        errorString.contains('HandshakeException') ||
        errorString.contains('Network is unreachable')) {
      return true;
    }

    return false;
  }

  static void success(String message) {
    if (kDebugMode) _logger.i('✅ SUCCESS: $message');
  }
}
