import 'package:get_it/get_it.dart';
import 'package:sana/core/services/local_storage/local_storage_service.dart';
import 'package:sana/features/asma_ul_husna/di/asma_ul_husna_di.dart';
import 'package:sana/features/azkar/di/azkar_di.dart';
import 'package:sana/features/daily_content/di/daily_content_di.dart';
import 'package:sana/features/quran/data/repos/quran_repo.dart';
import 'package:sana/features/quran/presentation/cubit/quran_cubit.dart';
import 'package:sana/features/salat_ala_Nabi/data/repo/reminder_repo.dart';
import 'package:sana/features/salat_ala_Nabi/data/services/notification_service.dart';
import 'package:sana/core/services/device_info/device_info_service.dart';
import 'package:sana/core/services/permissions/app_permissions_manager.dart';
import 'package:sana/features/salat_ala_Nabi/presentation/controller/reminder_cubit.dart';
import 'package:sana/features/teaching_prayer/di/teaching_prayer_di.dart';

void setupOtherFeaturesDependencies(GetIt sl) {
  sl
  // 0) Notification Service
  .registerLazySingleton<NotificationService>(NotificationService.new);
  // 2) Daily Content
  DailyContentDependencyInjection.init(sl);
  // 3) Asma ul Husna
  AsmaUlHusnaDependencyInjection.init(sl);
  sl
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
    );
  // 4) Teaching Prayer
  TeachingPrayerDependencyInjection.init(sl);

  // 11) Azkar
  AzkarDependencyInjection.init(sl);

  // 12) Quran
  sl
    ..registerLazySingleton<IQuranRepo>(QuranRepoImpl.new)
    ..registerFactory<QuranCubit>(() => QuranCubit(sl<IQuranRepo>()));
}
