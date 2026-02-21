import 'package:get_it/get_it.dart';
import 'package:sana/core/services/sharedpref/shared_pref.dart';
import 'package:sana/core/utils/date_gregorian_and_hijri/cubit/app_date_cubit.dart';
import 'package:sana/features/asma_ul_husna/presentation/cubit/asma_ul_husna_cubit.dart';
import 'package:sana/features/daily_content/data/repositories/daily_content_repository.dart';
import 'package:sana/features/daily_content/presentation/controller/daily_content_cubit.dart';
import 'package:sana/features/salat_ala_Nabi/data/repo/reminder_repo.dart';
import 'package:sana/features/salat_ala_Nabi/presentation/cubit/reminder_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void setupOtherFeaturesDependencies(GetIt sl) {
  // 1) Daily Content Repository
  sl
    ..registerLazySingleton<DailyContentRepository>(
      () => DailyContentRepository(sl<SharedPreferences>()),
    )
    // 2) Daily Content Cubit
    ..registerFactory<DailyContentCubit>(
      () => DailyContentCubit(sl<AppDateCubit>(), sl<DailyContentRepository>()),
    )
    // 3) Asma ul Husna Cubit
    ..registerFactory<AsmaUlHusnaCubit>(AsmaUlHusnaCubit.new)
    // 2) Reminder (Salat ala Nabi) Repository
    ..registerLazySingleton<ReminderRepo>(
      () => ReminderRepo(sharedPref: sl<SharedPref>()),
    )
    // 3) Reminder Cubit
    ..registerFactory<ReminderCubit>(() => ReminderCubit(sl<ReminderRepo>()));
}
