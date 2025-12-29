import 'package:firebase_core/firebase_core.dart';
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
import 'package:sana/core/di/location_di.dart';
import 'package:sana/core/di/other_features_di.dart';
import 'package:sana/core/di/prayer_di.dart';
import 'package:sana/core/di/qibla_di.dart';
import 'package:sana/core/utils/bloc_observer.dart';
import 'package:sana/features/salat_ala_Nabi/data/services/work_manager_service.dart';
import 'package:sana/firebase_options.dart';
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
  WidgetsFlutterBinding.ensureInitialized();

  initializeDateFormatting(AppConstants.locale);

  // Parallelize independent initializations to reduce startup time
  await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    setupLocator(),
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
  ]);

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

  // QuranLibrary & WorkManager can also be initialized in parallel if safe
  await Future.wait([
    QuranLibrary.init(),
    if (!kIsWeb) Workmanager().initialize(callbackDispatcher),
  ]);
}
