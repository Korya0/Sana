import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart';
import 'package:quran_library/quran.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/di/azkar_di.dart';
import 'package:sana/core/di/core_di.dart';
import 'package:sana/core/di/location_di.dart';
import 'package:sana/core/di/other_features_di.dart';
import 'package:sana/core/di/prayer_di.dart';
import 'package:sana/core/di/qibla_di.dart';
import 'package:sana/core/utils/bloc_observer.dart';
import 'package:sana/features/salat_ala_Nabi/data/services/work_manager_service.dart';
import 'package:workmanager/workmanager.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  await setupCoreDependencies(sl);
  setupLocationDependencies(sl);
  setupPrayerDependencies(sl);
  setupAzkarDependencies(sl);
  setupQiblaDependencies(sl);
  setupOtherFeaturesDependencies(sl);
}

Future<void> initializeApp() async {
  final logger = Logger();

  // Global Error Handling
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    logger.e(
      '[FlutterError]',
      error: details.exception,
      stackTrace: details.stack,
    );
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    logger.e('[PlatformError]', error: error, stackTrace: stack);
    return true;
  };

  // Parallelize independent initializations to reduce startup time
  try {
    // These are fast or non-blocking UI calls
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    await initializeDateFormatting(AppConstants.locale);
    await setupLocator().timeout(const Duration(seconds: 10));
  } catch (e) {
    logger.e('Startup initialization error or timeout', error: e);
    // Proceeding to allow the app to boot even if some services are slow
  }

  // Bloc observer
  Bloc.observer = AppBlocObserver();

  // Set Hijri locale immediately
  HijriCalendar.setLocal(AppConstants.locale);

  // جعل شريط الحالة شفاف
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
}

bool _heavyServicesInitialized = false;

Future<void> initializeAppPostFrame() async {
  if (_heavyServicesInitialized) return;
  _heavyServicesInitialized = true;
  await _initHeavyServices();
}

Future<void> _initHeavyServices() async {
  try {
    await QuranLibrary.init();
    if (!kIsWeb) {
      await Workmanager().initialize(callbackDispatcher);
    }
  } catch (e) {
    Logger().e('Error initializing heavy services', error: e);
  }
}
