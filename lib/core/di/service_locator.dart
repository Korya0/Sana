import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:quran_library/quran.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/di/azkar_di.dart';
import 'package:sana/core/di/core_di.dart';
import 'package:sana/core/di/hadith_di.dart';
import 'package:sana/core/di/home_di.dart';
import 'package:sana/core/di/location_di.dart';
import 'package:sana/core/di/other_features_di.dart';
import 'package:sana/core/di/prayer_di.dart';
import 'package:sana/core/di/qibla_di.dart';
import 'package:sana/core/di/report_di.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/core/utils/bloc_observer.dart';
import 'package:sana/features/salat_ala_Nabi/data/services/work_manager_service.dart';
import 'package:sana/core/networking/firebase/firebase_options.dart';
import 'package:sana/core/di/developer_dashboard_di.dart';
import 'package:sana/features/prayer/data/services/religious_events_service.dart';
import 'package:quran_library/quran_library.dart';

final GetIt sl = GetIt.instance;

Future<void> setupLocator() async {
  await setupCoreDependencies(sl);
  setupLocationDependencies(sl);
  setupPrayerDependencies(sl);
  setupAzkarDependencies(sl);
  setupHomeDependencies(sl);
  setupQiblaDependencies(sl);
  setupFeedbackDependencies(sl);
  setupOtherFeaturesDependencies(sl);
  setupHadithDependencies(sl);
  setupDeveloperDashboardDependencies(sl);
}

Future<void> initializeApp() async {
  try {
    // 1. Initialize Firebase first as it's a prerequisite for many dependencies
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    if (!kIsWeb) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
        !kDebugMode,
      );
    }

    // Global Error Handling
    if (!kIsWeb) {
      FlutterError.onError = (details) async {
        await FirebaseCrashlytics.instance.recordFlutterFatalError(details);
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

      PlatformDispatcher.instance.onError = (error, stack) {
        unawaited(
          AppLogger.error('[PlatformError]', error: error, stackTrace: stack),
        );
        return true;
      };
    }

    // 2. Run independent initializations in parallel
    await Future.wait([
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
      initializeDateFormatting(AppConstants.locale),
      setupLocator(),
    ]);

    // 2.5 Quick init heavy services that are needed for first frame
    await sl<ReligiousEventsService>().init();

    // 3. Post-locator configuration
    Bloc.observer = AppBlocObserver();
    HijriCalendar.setLocal(AppConstants.locale);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  } catch (e, stack) {
    unawaited(
      AppLogger.error(
        'Critical startup initialization error',
        error: e,
        stackTrace: stack,
      ),
    );
    // Rethrow to avoid running the app in a broken state
    rethrow;
  }
}

bool _heavyServicesInitialized = false;

Future<void> initializeAppPostFrame() async {
  if (_heavyServicesInitialized) return;
  _heavyServicesInitialized = true;

  // Give the UI a tiny bit of breathing room
  await Future<void>.delayed(const Duration(milliseconds: 200));

  await _initHeavyServices();
}

Future<void> _initHeavyServices() async {
  try {
    // 1. Initialize heavy libraries
    await QuranLibrary.init();

    if (!kIsWeb) {
      await WorkManagerService.initialize();
    }

    // 2. Background Warm-up: Fetch remote config to have it ready for later
    // This improves the experience for the update overlay and other dynamic features
    unawaited(
      sl<FirebaseRemoteConfig>().fetchAndActivate().catchError((_) => false),
    );

    // 3. Add any other non-critical background initializations here
    // Example: Analytics, Pre-caching assets, etc.
  } catch (e) {
    await AppLogger.error('Error in post-frame initialization', error: e);
  }
}
