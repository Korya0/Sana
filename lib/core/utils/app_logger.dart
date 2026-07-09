import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// AppLogger provides centralized logging and crash reporting.
/// 
/// ### 🚨 RULE: Log Once at the Source (قاعدة تسجيل الخطأ مرة واحدة)
/// To prevent duplicate error logging across layers (e.g. DataSource -> Repo -> Cubit -> UI):
/// 1. **Data Layer (Repository/DataSource)**: Catch exceptions and call `AppLogger.error` **once** at the source.
///    Return the error wrapped in a `Result.failure(Failure)`.
/// 2. **Logic Layer (Cubit/UseCases)**: Handle `Result.failure` quietly by updating state (e.g. `ErrorState`).
///    **DO NOT** log the error again with `AppLogger.error`.
/// 3. **UI Layer (Widgets)**: Show the error message (e.g. Toast/Dialog). **DO NOT** call `AppLogger.error`.
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

      final errorHash = Object.hash(
        error?.runtimeType,
        error?.toString(),
        message,
      );
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
    final deservesFirebase = report || _checkIfFirebaseWorthy(error);

    if (deservesFirebase) {
      await reportToFirebase(message, error: error, stackTrace: stackTrace);
    } else {
      await localError(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Determines if an exception/error is a critical system failure that deserves
  /// reporting to Firebase Crashlytics, or a benign/expected one that should stay local.
  static bool _checkIfFirebaseWorthy(Object? error) {
    if (error == null) return false;

    // Ignore benign network errors (SocketException, HandshakeException, etc.)
    if (_shouldIgnoreError(error)) return false;

    final errorStr = error.toString().toLowerCase();

    // Ignore user permission denials and service disablements
    if (errorStr.contains('permission') || 
        errorStr.contains('denied') || 
        errorStr.contains('disabled')) {
      return false;
    }

    // Ignore client network failures (HTTP 4xx like 401, 404, 403)
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      if (statusCode != null && statusCode >= 400 && statusCode < 500) {
        return false;
      }
    }

    // Capture DB corruption, programming crashes (null-pointers, types, asset crashes)
    if (error is TypeError ||
        error is AssertionError ||
        error is NoSuchMethodError ||
        errorStr.contains('hive') ||
        errorStr.contains('database') ||
        errorStr.contains('null check') ||
        errorStr.contains('nullcheckoperator')) {
      return true;
    }

    // For other unexpected system exceptions, default to true in production
    return true;
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
