import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/services/firebase/firebase_options.dart';
import 'package:sana/core/utils/app_logger.dart';

/// Responsible for initializing Firebase and setting up Crashlytics/Performance.
class FirebaseBootstrapper {
  const FirebaseBootstrapper();

  /// Initializes Firebase with a timeout. If it fails, the app continues
  /// without Firebase services.
  Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ).timeout(AppConstants.hiveInitTimeout2s);
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.reportToFirebase(
          'Firebase initialization delayed or failed, continuing without it for now',
          error: e,
          stackTrace: stack,
        ),
      );
    }
  }

  /// Sets up Crashlytics collection (only in release mode).
  Future<void> setupCrashlytics() async {
    if (Firebase.apps.isEmpty || kIsWeb) return;
    try {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
        kReleaseMode,
      );
      if (kReleaseMode) {
        await FirebaseCrashlytics.instance.log('App Started');
      }
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.localError(
          'Failed to setup crashlytics',
          error: e,
          stackTrace: stack,
        ),
      );
    }
  }

  /// Sets up Performance monitoring collection.
  Future<void> setupPerformance() async {
    if (Firebase.apps.isEmpty) return;
    await FirebasePerformance.instance.setPerformanceCollectionEnabled(true);
  }
}
