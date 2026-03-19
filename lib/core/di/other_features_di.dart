import 'package:get_it/get_it.dart';
import 'package:sana/core/services/local_storage/local_storage_service.dart';
import 'package:sana/features/app_date/presentation/controller/app_date_cubit.dart';
import 'package:sana/features/asma_ul_husna/data/repositories/asma_ul_husna_repository.dart';
import 'package:sana/features/asma_ul_husna/presentation/controller/asma_ul_husna_cubit.dart';
import 'package:sana/features/daily_content/data/repositories/daily_content_repository.dart';
import 'package:sana/features/daily_content/presentation/controller/daily_content_cubit.dart';
import 'package:sana/features/quran/data/repos/quran_repo.dart';
import 'package:sana/features/quran/presentation/cubit/quran_cubit.dart';
import 'package:sana/features/salat_ala_Nabi/data/repo/reminder_repo.dart';
import 'package:sana/features/salat_ala_Nabi/data/services/notification_service.dart';
import 'package:sana/core/services/device_info/device_info_service.dart';
import 'package:sana/core/services/permissions/app_permissions_manager.dart';
import 'package:sana/features/salat_ala_Nabi/presentation/controller/reminder_cubit.dart';
import 'package:sana/features/teaching_prayer/data/datasources/teaching_prayer_local_data_source.dart';
import 'package:sana/features/teaching_prayer/data/repositories/teaching_prayer_repository.dart';
import 'package:sana/features/teaching_prayer/presentation/controller/teaching_prayer_cubit.dart';

void setupOtherFeaturesDependencies(GetIt sl) {
  sl
    // 0) Notification Service
    ..registerLazySingleton<NotificationService>(NotificationService.new)
    // 1) Daily Content Repository
    ..registerLazySingleton<IDailyContentRepository>(
      () => DailyContentRepositoryImpl(sl<ILocalStorageService>()),
    )
    // 2) Daily Content Cubit
    ..registerLazySingleton<DailyContentCubit>(
      () => DailyContentCubit(
        sl<AppDateCubit>(),
        sl<IDailyContentRepository>(),
        sl<IAsmaUlHusnaRepository>(),
      ),
    )
    ..registerLazySingleton<IAsmaUlHusnaRepository>(
      AsmaUlHusnaRepository.new,
    )
    // 4) Asma ul Husna Cubit
    ..registerFactory<AsmaUlHusnaCubit>(
      () => AsmaUlHusnaCubit(sl<IAsmaUlHusnaRepository>()),
    )
    // 5) Reminder (Salat ala Nabi) Repository
    ..registerLazySingleton<IReminderRepo>(
      () => ReminderRepoImpl(sharedPref: sl<ILocalStorageService>()),
    )
    // 6) Reminder Cubit
    ..registerFactory<ReminderCubit>(
      () => ReminderCubit(
        sl<IReminderRepo>(),
        sl<NotificationService>(),
        sl<IAppPermissionsManager>(),
        sl<IDeviceInfoService>(),
      ),
    )
    // 7) Teaching Prayer
    ..registerLazySingleton<TeachingPrayerLocalDataSource>(
      TeachingPrayerLocalDataSource.new,
    )
    ..registerLazySingleton<ITeachingPrayerRepository>(
      () => TeachingPrayerRepository(sl<TeachingPrayerLocalDataSource>()),
    )
    // 8) Teaching Prayer Cubit
    ..registerFactory<TeachingPrayerCubit>(
      () => TeachingPrayerCubit(repository: sl<ITeachingPrayerRepository>()),
    )
    // 9) Quran
    ..registerLazySingleton<IQuranRepo>(QuranRepoImpl.new)
    ..registerFactory<QuranCubit>(() => QuranCubit(sl<IQuranRepo>()));
}
