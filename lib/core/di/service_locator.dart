import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sana/core/common/slivers/animated_sliver_list.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/di/core_di.dart';
import 'package:sana/core/di/features_di.dart';
import 'package:sana/core/services/background/i_work_manager_service.dart';
import 'package:sana/core/services/firebase/firebase_options.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/core/utils/bloc_observer.dart';
import 'package:sana/features/salat_ala_nabi/data/services/salawat_background_executor.dart';

final GetIt sl = GetIt.instance;

Future<void> setupLocator() async {
  await setupCoreDependencies(sl);
  setupFeaturesDependencies(sl);
}

Future<void> initializeApp() async {
  try {
    try {
      await Future.wait([
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge),
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
        initializeDateFormatting(AppConstants.ar),
      ]).timeout(const Duration(seconds: 2));
    } on Exception catch (e) {
      AppLogger.warn('System setup delayed or failed: $e');
    }

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ).timeout(const Duration(seconds: 2));
    } on Exception catch (e) {
      AppLogger.warn('Firebase initialization delayed or failed, continuing without it for now: $e');
    }

    await setupLocator();

    if (!kIsWeb) {
      unawaited(_setupCrashlytics());
    }

    _setupGlobalErrorHandlers();

    Bloc.observer = AppBlocObserver();
    HijriCalendar.setLocal(AppConstants.ar);
    AnimatedSliverList.globalDefaultAnimation =
        (context, child, index, duration, delay) => child
            .animate(delay: delay)
            .fadeIn(duration: duration)
            .slideY(
              begin: 0.2,
              end: 0,
              duration: duration,
            );

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  } on Exception catch (e, stack) {
    unawaited(
      AppLogger.error('Critical startup failure', error: e, stackTrace: stack),
    );
    rethrow;
  }
}

Future<void> _setupCrashlytics() async {
  try {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
      kReleaseMode,
    );
    if (kReleaseMode) {
      await FirebaseCrashlytics.instance.log('App Started');
    }
  } on Exception catch (e) {
    AppLogger.warn('Failed to setup crashlytics: $e');
  }
}

Future<void> _setupPerformance() async {
  await FirebasePerformance.instance.setPerformanceCollectionEnabled(
    true,
  );
}

void _setupGlobalErrorHandlers() {
  if (!kIsWeb) {
    FlutterError.onError = (details) {
      if (kReleaseMode) {
        unawaited(
          FirebaseCrashlytics.instance.recordFlutterFatalError(details),
        );
      }
      FlutterError.presentError(details);
      unawaited(
        AppLogger.error(
          '[FlutterError]',
          error: details.exception,
          stackTrace: details.stack,
        ),
      );
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      if (kReleaseMode) {
        unawaited(
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true),
        );
      }
      unawaited(
        AppLogger.error('[PlatformError]', error: error, stackTrace: stack),
      );
      return true;
    };
  } else {
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      unawaited(
        AppLogger.error(
          '[FlutterError]',
          error: details.exception,
          stackTrace: details.stack,
        ),
      );
    };
  }
}

bool _heavyServicesInitialized = false;

Future<void> initializeAppPostFrame() async {
  if (_heavyServicesInitialized) return;
  _heavyServicesInitialized = true;

  await Future<void>.delayed(const Duration(seconds: 1));
  await _initHeavyServices();
}

Future<void> _initHeavyServices() async {
  try {
    if (!kIsWeb) {
      await sl<IWorkManagerService>().initialize(salawatCallbackDispatcher);
      unawaited(_setupPerformance());
    }

    // Delay Remote Config slightly more to avoid CPU contention
    unawaited(
      Future<void>.delayed(const Duration(seconds: 30)).then(
        (_) => sl<FirebaseRemoteConfig>()
            .fetchAndActivate()
            .then((_) => AppLogger.info('Remote Config activated'))
            .catchError((e) => false),
      ),
    );
  } on Exception catch (e, stack) {
    unawaited(
      AppLogger.error(
        'Error in post-frame initialization',
        error: e,
        stackTrace: stack,
      ),
    );
  }
}
