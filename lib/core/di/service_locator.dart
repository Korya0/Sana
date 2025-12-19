import 'package:adhan/adhan.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:quran_library/quran.dart';
import 'package:sana/core/services/date_gregorian_and_hijri/cubit/app_date_cubit.dart';
import 'package:sana/core/services/location/controller/location_name/location_name_cubit.dart';
import 'package:sana/core/services/location/data/location_name_service.dart';
import 'package:sana/core/services/location/data/location_repo.dart';
import 'package:sana/core/services/location/data/location_service.dart';
import 'package:sana/core/services/sharedpref/shared_pref.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/services/share_service.dart';
import 'package:sana/core/utils/bloc_observer.dart';
import 'package:sana/features/azkar/data/datasource/azkar_local_data_source.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';
import 'package:sana/features/prayer/data/services/prayer_times_service.dart';
import 'package:sana/features/prayer/data/services/user_settings_service.dart';
import 'package:sana/features/prayer/presentation/cubit/prayer_times_cubit.dart';
import 'package:sana/features/qibla/data/repositories/qibla_repository.dart';
import 'package:sana/features/qibla/presentation/cubit/qibla_cubit.dart';
import 'package:sana/features/salat_ala_Nabi/presentation/cubit/reminder_cubit.dart';
import 'package:sana/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sana/features/salat_ala_Nabi/data/repo/reminder_repo.dart';
import 'package:sana/features/salat_ala_Nabi/data/services/work_manager_service.dart';
import 'package:sana/features/home/data/datasources/features_local_data_source.dart';
import 'package:sana/features/home/data/model/category_item.dart';
import 'package:sana/features/home/data/repositories/sortable_category_repository.dart';
import 'package:sana/features/home/presentation/cubit/sortable_category_cubit.dart';
import 'package:sana/core/services/sharedpref/pref_keys.dart';
import 'package:sana/features/asma_ul_husna/presentation/cubit/asma_ul_husna_cubit.dart';
import 'package:workmanager/workmanager.dart';

import '../constants/app_constants.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  // 1) SharedPref
  final sharedPref = SharedPref();
  await sharedPref.instantiatePreferences();
  sl.registerLazySingleton<SharedPref>(() => sharedPref);

  sl.registerLazySingleton<Dio>(() => Dio());

  // 2) LocationService
  sl.registerLazySingleton<LocationService>(() => LocationService());

  // 3) LocationRepo
  sl.registerLazySingleton<LocationRepo>(
    () => LocationRepoImpl(
      locationService: sl<LocationService>(),
      sharedPref: sl<SharedPref>(),
    ),
  );

  // Services
  sl.registerLazySingleton<UserSettingsService>(() => UserSettingsService());
  sl.registerLazySingleton<PrayerTimesService>(() => PrayerTimesService());

  sl.registerLazySingleton<AppDateCubit>(() => AppDateCubit());

  final latitude = sl<SharedPref>().getDouble(PrefKeys.latitude) ?? 30.968333;
  final longitude = sl<SharedPref>().getDouble(PrefKeys.longitude) ?? 31.021667;

  sl.registerFactory<PrayerTimesCubit>(
    () => PrayerTimesCubit(
      prayerTimesService: sl<PrayerTimesService>(),
      settingsService: sl<UserSettingsService>(),
      coords: Coordinates(latitude, longitude),
      appDateCubit: sl<AppDateCubit>(),
    ),
  );

  // Service
  sl.registerLazySingleton<LocationNameService>(() => LocationNameService());

  // Cubit
  sl.registerFactory<LocationNameCubit>(
    () => LocationNameCubit(
      service: sl<LocationNameService>(),
      prefs: sl<SharedPref>(),
    ),
  );
  // Cubit

  // Share Service
  sl.registerLazySingleton<ShareService>(() => ShareServiceImpl());

  // 7) Qibla Repository & Cubit
  sl.registerLazySingleton<QiblaRepository>(
    () => QiblaRepository(sharedPref: sl<SharedPref>()),
  );
  sl.registerFactory<QiblaCubit>(() => QiblaCubit(sl<QiblaRepository>()));

  // 8) Azkar & Features Dependencies
  // DataSources
  sl.registerLazySingleton<AzkarLocalDataSource>(() => AzkarLocalDataSource());
  sl.registerLazySingleton<FeaturesLocalDataSource>(
    () => FeaturesLocalDataSource(),
  );

  // Repositories
  sl.registerLazySingleton<SortableCategoryRepository<AzkarCategoryModel>>(
    () => SortableCategoryRepository<AzkarCategoryModel>(
      dataSourceGetter: () => sl<AzkarLocalDataSource>().getAllCategories(),
      prefKey: PrefKeys.azkarCategoryUsage,
    ),
  );
  sl.registerLazySingleton<SortableCategoryRepository<CategoryItem>>(
    () => SortableCategoryRepository<CategoryItem>(
      dataSourceGetter: () async => sl<FeaturesLocalDataSource>().getFeatures(),
      prefKey: PrefKeys.allFeaturesUsage,
    ),
  );

  // Cubits
  sl.registerFactory<SortableCategoryCubit<AzkarCategoryModel>>(
    () => SortableCategoryCubit<AzkarCategoryModel>(
      sl<SortableCategoryRepository<AzkarCategoryModel>>(),
    ),
  );
  sl.registerFactory<SortableCategoryCubit<CategoryItem>>(
    () => SortableCategoryCubit<CategoryItem>(
      sl<SortableCategoryRepository<CategoryItem>>(),
    ),
  );

  // Cubit
  sl.registerFactory<AsmaUlHusnaCubit>(() => AsmaUlHusnaCubit());
}

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  initializeDateFormatting(AppConstants.locale);

  // FireBase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Bloc observer
  Bloc.observer = AppBlocObserver();

  // Setup DI
  await setupLocator();

  // Device orientation
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // جعل شريط الحالة شفاف
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
  // Initialize date formatting
  await initializeDateFormatting();

  // Set Hijri locale immediately
  HijriCalendar.setLocal(AppConstants.locale);
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  //  ReminderRepo
  sl.registerLazySingleton(() => ReminderRepo(sharedPref: sl<SharedPref>()));

  // ReminderCubit
  sl.registerFactory(() => ReminderCubit(sl<ReminderRepo>()));

  // Initialize WorkManager for background tasks
  if (!kIsWeb) {
    Workmanager().initialize(callbackDispatcher);
  }

  // QuranLibrary
  await QuranLibrary.init();
}
