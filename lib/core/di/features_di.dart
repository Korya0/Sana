import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get_it/get_it.dart';
import 'package:sana/core/services/app_date/data/repositories/app_date_repository.dart';
import 'package:sana/core/services/app_date/presentation/controller/app_date_cubit.dart';
import 'package:sana/core/services/app_update/data/repositories/app_update_repository.dart';
import 'package:sana/core/services/app_update/data/services/app_update_service.dart';
import 'package:sana/core/services/app_update/presentation/controller/app_update_cubit.dart';
import 'package:sana/core/services/device_info/device_info_service.dart';
import 'package:sana/core/services/local_storage/local_storage_service.dart';
import 'package:sana/core/services/location_manager/data/datasources/location_local_data_source.dart';
import 'package:sana/core/services/location_manager/data/datasources/location_remote_data_source.dart';
import 'package:sana/core/services/location_manager/data/repositories/location_repository.dart';
import 'package:sana/core/services/location_manager/presentation/controller/location_name/location_name_cubit.dart';
import 'package:sana/core/services/location_manager/presentation/controller/location_permission/location_cubit.dart';
import 'package:sana/core/services/background/i_work_manager_service.dart';
import 'package:sana/core/services/notification/i_notification_service.dart';
import 'package:sana/core/services/permissions/app_permissions_manager.dart';
import 'package:sana/core/services/sharing/logic/share_service.dart';
import 'package:sana/features/asma_ul_husna/data/repos/asma_ul_husna_repository.dart';
import 'package:sana/features/asma_ul_husna/presentation/cubit/asma_ul_husna_cubit.dart';
import 'package:sana/features/azkar/data/datasources/azkar_local_data_source.dart';
import 'package:sana/features/azkar/data/repos/azkar_repository.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar_categories_cubit.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar_category_loader_cubit.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar_list_cubit.dart';
import 'package:sana/features/daily_content/data/repos/daily_content_repository.dart';
import 'package:sana/features/daily_content/presentation/cubit/daily_content_cubit.dart';
import 'package:sana/features/developer_dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:sana/features/developer_dashboard/data/repos/dashboard_repository.dart';
import 'package:sana/features/developer_dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:sana/features/feedback/data/datasources/feedback_remote_data_source.dart';
import 'package:sana/features/feedback/data/repos/feedback_repository.dart';
import 'package:sana/features/feedback/presentation/cubit/feedback_cubit.dart';
import 'package:sana/features/hadith_search/data/datasources/hadith_remote_data_source.dart';
import 'package:sana/features/hadith_search/data/datasources/i_hadith_remote_data_source.dart';
import 'package:sana/features/hadith_search/data/repos/hadith_favorites_repository.dart';
import 'package:sana/features/hadith_search/data/repos/hadith_repository.dart';
import 'package:sana/features/hadith_search/domain/repositories/i_hadith_favorites_repository.dart';
import 'package:sana/features/hadith_search/domain/repositories/i_hadith_repository.dart';
import 'package:sana/features/hadith_search/domain/use_cases/search_hadith_use_case.dart';
import 'package:sana/features/hadith_search/presentation/cubit/hadith_favorites/hadith_favorites_cubit.dart';
import 'package:sana/features/hadith_search/presentation/cubit/hadith_search/hadith_search_cubit.dart';
import 'package:sana/features/home/data/datasources/features_local_data_source.dart';
import 'package:sana/features/home/data/repos/features_repository.dart';
import 'package:sana/features/home/presentation/cubit/features_list_cubit.dart';
import 'package:sana/features/prayer/data/repos/prayer_repository.dart';
import 'package:sana/features/prayer/data/services/prayer_state_service.dart';
import 'package:sana/features/prayer/data/services/prayer_status_service.dart';
import 'package:sana/features/prayer/data/services/prayer_times_service.dart';
import 'package:sana/features/prayer/data/services/religious_events_service.dart';
import 'package:sana/features/prayer/data/services/user_settings_service.dart';
import 'package:sana/features/prayer/presentation/cubit/prayer_times_cubit.dart';
import 'package:sana/features/qibla/data/datasources/qibla_local_data_source.dart';
import 'package:sana/features/qibla/data/repos/qibla_repository.dart';
import 'package:sana/features/qibla/data/services/qibla_service.dart';
import 'package:sana/features/qibla/presentation/cubit/qibla_cubit.dart';
import 'package:sana/features/quran/data/repos/quran_repo.dart';
import 'package:sana/features/quran/domain/use_cases/initialize_quran_use_case.dart';
import 'package:sana/features/quran/presentation/cubit/quran_cubit.dart';
import 'package:sana/features/salat_ala_nabi/data/datasources/reminder_local_data_source.dart';
import 'package:sana/features/salat_ala_nabi/data/repos/reminder_repo.dart';
import 'package:sana/features/salat_ala_nabi/presentation/cubit/reminder_cubit.dart';
import 'package:sana/features/teaching_prayer/data/datasources/teaching_prayer_local_data_source.dart';
import 'package:sana/features/teaching_prayer/data/repos/teaching_prayer_repo_impl.dart';
import 'package:sana/features/teaching_prayer/presentation/cubit/teaching_prayer_cubit.dart';

void setupFeaturesDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<AppUpdateService>(
      () => AppUpdateServiceImpl(sl<FirebaseRemoteConfig>(), sl()),
    )
    ..registerLazySingleton<IAppUpdateRepository>(
      () => AppUpdateRepository(sl<AppUpdateService>()),
    )
    ..registerLazySingleton<AppUpdateCubit>(
      () => AppUpdateCubit(sl<IAppUpdateRepository>()),
    )
    ..registerLazySingleton<IAsmaUlHusnaRepository>(AsmaUlHusnaRepoImpl.new)
    ..registerFactory<AsmaUlHusnaCubit>(
      () => AsmaUlHusnaCubit(sl<IAsmaUlHusnaRepository>()),
    )
    ..registerLazySingleton<AzkarLocalDataSource>(AzkarLocalDataSource.new)
    ..registerLazySingleton<IAzkarRepository>(
      () => AzkarRepoImpl(sl<AzkarLocalDataSource>()),
    )
    ..registerFactory<AzkarCategoriesCubit>(
      () => AzkarCategoriesCubit(sl<IAzkarRepository>()),
    )
    ..registerFactory<AzkarCategoryLoaderCubit>(
      () => AzkarCategoryLoaderCubit(sl<IAzkarRepository>()),
    )
    ..registerFactory<AzkarListCubit>(AzkarListCubit.new)
    ..registerLazySingleton<IDailyContentRepository>(
      () => DailyContentRepoImpl(sl<ILocalStorageService>()),
    )
    ..registerLazySingleton<DailyContentCubit>(
      () => DailyContentCubit(
        sl<AppDateCubit>(),
        sl<IDailyContentRepository>(),
        sl<IAsmaUlHusnaRepository>(),
      ),
    )
    ..registerLazySingleton<IDashboardRemoteDataSource>(
      () => DashboardRemoteDataSource(sl<FirebaseFirestore>()),
    )
    ..registerLazySingleton<IDashboardRepository>(() => DashboardRepoImpl(sl()))
    ..registerFactory<DashboardCubit>(() => DashboardCubit(sl()))
    ..registerLazySingleton<FeedbackRemoteDataSource>(
      FeedbackRemoteDataSource.new,
    )
    ..registerLazySingleton<IFeedbackRepository>(
      () => FeedbackRepoImpl(
        sl<FeedbackRemoteDataSource>(),
        sl<IDeviceInfoService>(),
      ),
    )
    ..registerFactory<FeedbackCubit>(
      () => FeedbackCubit(repository: sl<IFeedbackRepository>()),
    )
    ..registerLazySingleton<IHadithRemoteDataSource>(
      () => HadithRemoteDataSource(sl()),
    )
    ..registerLazySingleton<IHadithRepository>(() => HadithRepoImpl(sl()))
    ..registerLazySingleton<IHadithFavoritesRepository>(
      () => HadithFavoritesRepoImpl(sl<ILocalStorageService>()),
    )
    ..registerLazySingleton<SearchHadithUseCase>(
      () => SearchHadithUseCase(sl()),
    )
    ..registerFactory<HadithCubit>(() => HadithCubit(sl()))
    ..registerLazySingleton<HadithFavoritesCubit>(
      () => HadithFavoritesCubit(sl()),
    )
    ..registerLazySingleton<FeaturesLocalDataSource>(
      FeaturesLocalDataSource.new,
    )
    ..registerLazySingleton<IFeaturesRepository>(() => FeaturesRepoImpl(sl()))
    ..registerFactory<FeaturesListCubit>(() => FeaturesListCubit(sl()))
    ..registerLazySingleton<LocationLocalDataSource>(
      () => LocationLocalDataSource(sl<IAppPermissionsManager>()),
    )
    ..registerLazySingleton<LocationRemoteDataSource>(
      () => LocationRemoteDataSource(sl()),
    )
    ..registerLazySingleton<ILocationRepository>(
      () => LocationRepository(
        localDataSource: sl<LocationLocalDataSource>(),
        remoteDataSource: sl<LocationRemoteDataSource>(),
        sharedPref: sl<ILocalStorageService>(),
      ),
    )
    ..registerFactory<LocationNameCubit>(
      () => LocationNameCubit(
        repository: sl<ILocationRepository>(),
        prefs: sl<ILocalStorageService>(),
        locationCubit: sl<LocationCubit>(),
      ),
    )
    ..registerLazySingleton<LocationCubit>(
      () => LocationCubit(repository: sl<ILocationRepository>()),
    )
    ..registerLazySingleton<UserSettingsService>(
      () => UserSettingsService(sl()),
    )
    ..registerLazySingleton<ReligiousEventsService>(ReligiousEventsService.new)
    ..registerLazySingleton<PrayerStateService>(
      () => const PrayerStateService(),
    )
    ..registerLazySingleton<PrayerStatusService>(PrayerStatusService.new)
    ..registerLazySingleton<PrayerTimesService>(
      () => PrayerTimesService(settingsService: sl(), stateService: sl()),
    )
    ..registerLazySingleton<IPrayerRepository>(
      () => PrayerRepoImpl(sl<ILocalStorageService>()),
    )
    ..registerLazySingleton<PrayerTimesCubit>(
      () => PrayerTimesCubit(
        prayerTimesService: sl<PrayerTimesService>(),
        prayerRepository: sl<IPrayerRepository>(),
        settingsService: sl<UserSettingsService>(),
        appDateCubit: sl<AppDateCubit>(),
        locationCubit: sl<LocationCubit>(),
        religiousEventsService: sl<ReligiousEventsService>(),
        prayerStatusService: sl<PrayerStatusService>(),
      ),
    )
    ..registerLazySingleton<IQiblaLocalDataSource>(
      () => QiblaLocalDataSource(sl<ILocalStorageService>()),
    )
    ..registerLazySingleton<IQiblaService>(QiblaServiceImpl.new)
    ..registerLazySingleton<IQiblaRepository>(
      () => QiblaRepoImpl(
        localDataSource: sl<IQiblaLocalDataSource>(),
        qiblaService: sl<IQiblaService>(),
      ),
    )
    ..registerFactory<QiblaCubit>(
      () => QiblaCubit(repository: sl<IQiblaRepository>()),
    )
    ..registerLazySingleton<IReminderLocalDataSource>(
      () => ReminderLocalDataSourceImpl(sl<ILocalStorageService>()),
    )
    ..registerLazySingleton<IReminderRepository>(
      () => ReminderRepositoryImpl(localDataSource: sl<IReminderLocalDataSource>()),
    )
    ..registerFactory<ReminderCubit>(
      () => ReminderCubit(
        sl<IReminderRepository>(),
        sl<INotificationService>(),
        sl<IWorkManagerService>(),
        sl<IAppPermissionsManager>(),
        sl<IDeviceInfoService>(),
      ),
    )
    ..registerLazySingleton<IQuranRepo>(QuranRepoImpl.new)
    ..registerLazySingleton<InitializeQuranUseCase>(
      () => InitializeQuranUseCase(sl<IQuranRepo>()),
    )
    ..registerFactory<QuranCubit>(() => QuranCubit(sl<InitializeQuranUseCase>()))
    ..registerLazySingleton<ITeachingPrayerLocalDataSource>(
      TeachingPrayerLocalDataSource.new,
    )
    ..registerLazySingleton<ITeachingPrayerRepository>(
      () => TeachingPrayerRepoImpl(sl<ITeachingPrayerLocalDataSource>()),
    )
    ..registerFactory<TeachingPrayerCubit>(
      () => TeachingPrayerCubit(sl<ITeachingPrayerRepository>()),
    )
    ..registerLazySingleton<IAppDateRepository>(
      () => AppDateRepositoryImpl(sl<ILocalStorageService>()),
    )
    ..registerLazySingleton<AppDateCubit>(
      () => AppDateCubit(sl<IAppDateRepository>()),
    )
    ..registerLazySingleton<ShareService>(ShareServiceImpl.new);
}
