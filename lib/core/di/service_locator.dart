import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sana/core/common/animations/app_animations.dart';
import 'package:sana/core/common/slivers/animated_sliver_list.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/di/core_di.dart';
import 'package:sana/features/developer_dashboard/di/developer_dashboard_di.dart';
import 'package:sana/features/feedback/di/feedback_di.dart';
import 'package:sana/features/hadith_search/di/hadith_search_di.dart';
import 'package:sana/core/di/home_di.dart';
import 'package:sana/core/di/location_di.dart';
import 'package:sana/core/di/other_features_di.dart';
import 'package:sana/core/di/prayer_di.dart';
import 'package:sana/core/di/qibla_di.dart';
import 'package:sana/core/services/firebase/firebase_options.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/core/utils/bloc_observer.dart';
import 'package:sana/features/location_manager/presentation/controller/location_permission/location_cubit.dart';
import 'package:sana/features/prayer/data/services/religious_events_service.dart';
import 'package:sana/features/salat_ala_Nabi/data/services/work_manager_service.dart';

final GetIt sl = GetIt.instance;

Future<void> setupLocator() async {
  await setupCoreDependencies(sl);
  setupLocationDependencies(sl);
  setupPrayerDependencies(sl);
  setupHomeDependencies(sl);
  setupQiblaDependencies(sl);
  FeedbackDependencyInjection.init(sl);
  setupOtherFeaturesDependencies(sl);
  HadithSearchDependencyInjection.init(sl);
  DeveloperDashboardDependencyInjection.init(sl);
}

Future<void> initializeApp() async {
  try {
    // 1. Critical Phase: Heavy lifting in Parallel
    // We run Firebase, Orientations, Locale, and Locator all at once to minimize splash time
    await Future.wait([
      Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
      initializeDateFormatting(AppConstants.locale),
      setupLocator(),
    ]);

    // 2. Error Tracking Initialization (Unawaited to not block)
    if (!kIsWeb) {
      unawaited(_setupCrashlytics());
      unawaited(_setupPerformance());
    }

    // 4. Global Error Handlers
    _setupGlobalErrorHandlers();

    // 5. App State Config
    Bloc.observer = AppBlocObserver();
    HijriCalendar.setLocal(AppConstants.locale);
    AnimatedSliverList.globalDefaultAnimation =
        (context, child, index, duration, delay) =>
            AppAnimations.fadeInUp(child, duration: duration, delay: delay);

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
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
    true,
  );
  // Log a custom message to know the app started successfully
  await FirebaseCrashlytics.instance.log('App Started');
}

Future<void> _setupPerformance() async {
  await FirebasePerformance.instance.setPerformanceCollectionEnabled(
    true,
  );
}

void _setupGlobalErrorHandlers() {
  if (!kIsWeb) {
    FlutterError.onError = (details) {
      unawaited(FirebaseCrashlytics.instance.recordFlutterFatalError(details));
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
      unawaited(
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true),
      );
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

  // Reduced delay to 100ms for snappier feel while still letting first frame render
  // ignore: inference_failure_on_instance_creation
  await Future.delayed(const Duration(milliseconds: 100));
  await _initHeavyServices();
}

Future<void> _initHeavyServices() async {
  try {
    // 1. High Priority Post-Frame (Parallel)
    await Future.wait([
      sl<ReligiousEventsService>().init(),
      if (!kIsWeb) WorkManagerService.initialize(),
    ]);

    // 2. Background Warm-up (Remote Config & Location)
    unawaited(
      sl<FirebaseRemoteConfig>()
          .fetchAndActivate()
          .then((_) => AppLogger.info('Remote Config activated'))
          .catchError((e) => false),
    );

    // Warm up the location permission state early
    // This makes screens like Qibla and Prayer Times much faster later
    unawaited(sl<LocationCubit>().checkLocationStatus());
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
