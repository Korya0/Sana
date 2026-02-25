import 'package:get_it/get_it.dart';
import 'package:sana/core/services/sharedpref/shared_pref.dart';
import 'package:sana/features/app_date/presentation/controller/app_date_cubit.dart';
import 'package:sana/features/asma_ul_husna/data/repositories/asma_ul_husna_repository.dart';
import 'package:sana/features/asma_ul_husna/presentation/controller/asma_ul_husna_cubit.dart';
import 'package:sana/features/daily_content/data/repositories/daily_content_repository.dart';
import 'package:sana/features/daily_content/presentation/controller/daily_content_cubit.dart';
import 'package:sana/features/salat_ala_Nabi/data/repo/reminder_repo.dart';
import 'package:sana/features/salat_ala_Nabi/presentation/controller/reminder_cubit.dart';
import 'package:sana/features/teaching_prayer/data/repositories/teaching_prayer_repository.dart';
import 'package:sana/features/teaching_prayer/presentation/controller/teaching_prayer_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void setupOtherFeaturesDependencies(GetIt sl) {
  // 1) Daily Content Repository
  sl
    ..registerLazySingleton<DailyContentRepository>(
      () => DailyContentRepository(sl<SharedPreferences>()),
    )
    // 2) Daily Content Cubit
    ..registerFactory<DailyContentCubit>(
      () => DailyContentCubit(
        sl<AppDateCubit>(),
        sl<DailyContentRepository>(),
        sl<IAsmaUlHusnaRepository>(),
      ),
    )
    ..registerLazySingleton<IAsmaUlHusnaRepository>(
      () => AsmaUlHusnaRepository(sl<SharedPreferences>()),
    )
    // 4) Asma ul Husna Cubit
    ..registerFactory<AsmaUlHusnaCubit>(
      () => AsmaUlHusnaCubit(sl<IAsmaUlHusnaRepository>()),
    )
    // 5) Reminder (Salat ala Nabi) Repository
    ..registerLazySingleton<ReminderRepo>(
      () => ReminderRepo(sharedPref: sl<SharedPref>()),
    )
    // 6) Reminder Cubit
    ..registerFactory<ReminderCubit>(() => ReminderCubit(sl<ReminderRepo>()))
    // 7) Teaching Prayer Repository
    ..registerLazySingleton<ITeachingPrayerRepository>(
      TeachingPrayerRepository.new,
    )
    // 8) Teaching Prayer Cubit
    ..registerFactory<TeachingPrayerCubit>(
      () => TeachingPrayerCubit(sl<ITeachingPrayerRepository>()),
    );
}
