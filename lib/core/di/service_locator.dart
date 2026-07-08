import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/di/core_di.dart';
import 'package:sana/core/di/features_di.dart';
import 'package:sana/core/di/services_di.dart';
import 'package:sana/core/di/app_date_di.dart';
import 'package:sana/core/services/background/i_work_manager_service.dart';
import 'package:sana/core/services/firebase/firebase_options.dart';
import 'package:sana/core/services/notification/i_notification_service.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/salat_ala_nabi/data/services/salawat_background_executor.dart';

final GetIt sl = GetIt.instance;

Future<void> setupLocator() async {
  await setupCoreDependencies(sl);
  setupServicesDependencies(sl);
  setupAppDateDependencies(sl);
  setupFeaturesDependencies(sl);
}

Future<void> initializeApp() async {
  try {
    try {
      await Future.wait([
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge),
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
        initializeDateFormatting(AppConstants.ar),
      ]);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.reportToFirebase(
          'System setup delayed or failed',
          error: e,
          stackTrace: stack,
        ),
      );
    }

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ).timeout(const Duration(seconds: 2));
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.reportToFirebase(
          'Firebase initialization delayed or failed, continuing without it for now',
          error: e,
          stackTrace: stack,
        ),
      );
    }

    await setupLocator();

    if (!kIsWeb) {
      unawaited(_setupCrashlytics());
    }

    _setupGlobalErrorHandlers();

    Bloc.observer = AppBlocObserver();
    HijriCalendar.setLocal(AppConstants.ar);
  } on Exception catch (e, stack) {
    unawaited(
      AppLogger.reportToFirebase(
        'Critical startup failure',
        error: e,
        stackTrace: stack,
      ),
    );
    rethrow;
  }
}

Future<void> _setupCrashlytics() async {
  if (Firebase.apps.isEmpty) return;
  try {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
      kReleaseMode,
    );
    if (kReleaseMode) {
      await FirebaseCrashlytics.instance.log('App Started');
    }
  } on Exception catch (e, stack) {
    unawaited(
      AppLogger.localError(
        'Failed to setup crashlytics',
        error: e,
        stackTrace: stack,
      ),
    );
  }
}

Future<void> _setupPerformance() async {
  if (Firebase.apps.isEmpty) return;
  await FirebasePerformance.instance.setPerformanceCollectionEnabled(
    true,
  );
}

void _setupGlobalErrorHandlers() {
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
      await sl<INotificationService>().initialize();
      await sl<IWorkManagerService>().initialize(salawatCallbackDispatcher);
      unawaited(_setupPerformance());
    }

    // Delay Remote Config slightly more to avoid CPU contention
    if (Firebase.apps.isNotEmpty) {
      unawaited(
        Future<void>.delayed(const Duration(seconds: 30)).then(
          (_) => sl<FirebaseRemoteConfig>()
              .fetchAndActivate()
              .then((_) => AppLogger.info('Remote Config activated'))
              .catchError((e) => false),
        ),
      );
    }
  } on Exception catch (e, stack) {
    unawaited(
      AppLogger.reportToFirebase(
        'Error in post-frame initialization',
        error: e,
        stackTrace: stack,
      ),
    );
  }
}
