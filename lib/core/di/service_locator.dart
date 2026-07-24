import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sana/core/bootstrap/app_error_handler.dart';
import 'package:sana/core/bootstrap/firebase_bootstrapper.dart';
import 'package:sana/core/bootstrap/heavy_services_bootstrapper.dart';
import 'package:sana/core/bootstrap/lifecycle_manager.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/features/app_date/di/app_date_di.dart';
import 'package:sana/core/di/core_di.dart';
import 'package:sana/core/di/features_di.dart';
import 'package:sana/core/di/services_di.dart';
import 'package:sana/core/services/local_storage/local_storage_service.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/azkar/domain/repositories/reminder_repository.dart';
import 'package:sana/features/salat_ala_nabi/data/services/salawat_background_executor.dart';

final GetIt sl = GetIt.instance;

Future<void> setupLocator() async {
  await setupCoreDependencies(sl);
  setupServicesDependencies(sl);
  setupAppDateDependencies(sl);
  await setupFeaturesDependencies(sl);
}

Future<void> initializeApp() async {
  try {
    // 1. System-level setup
    try {
      await Future.wait([
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge),
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
        initializeDateFormatting(AppConstants.ar),
      ]);
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.reportToFirebase(
          'System setup delayed or failed',
          error: e,
          stackTrace: stack,
        ),
      );
    }

    // 2. Firebase initialization (delegated to FirebaseBootstrapper)
    const firebaseBootstrapper = FirebaseBootstrapper();
    await firebaseBootstrapper.initialize();

    // 3. DI setup
    await setupLocator();

    // 4. Crashlytics setup
    if (!kIsWeb) {
      unawaited(firebaseBootstrapper.setupCrashlytics());
    }

    // 5. Global error handlers
    const AppErrorHandler().setup();

    // 6. Bloc observer & Hijri calendar
    Bloc.observer = AppBlocObserver();
    HijriCalendar.setLocal(AppConstants.ar);
  } on Object catch (e, stack) {
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

/// Initializes heavy services after the first frame is rendered.
Future<void> initializeAppPostFrame() async {
  final heavyServices = HeavyServicesBootstrapper(
    notificationService: sl(),
    workManagerService: sl(),
    remoteConfig: sl(),
    salawatCallbackDispatcher: salawatCallbackDispatcher,
  );
  await heavyServices.initialize();

  if (!kIsWeb) {
    // Store current timezone and set up lifecycle observer
    final lifecycleManager = LifecycleManager(
      localStorageService: sl<LocalStorageService>(),
      reminderRepository: sl(),
    );
    await lifecycleManager.storeCurrentTimezone();
    lifecycleManager.start();

    // Reschedule all active reminders
    unawaited(sl<ReminderRepository>().rescheduleAllActiveReminders());

    // Performance monitoring
    unawaited(const FirebaseBootstrapper().setupPerformance());
  }
}
