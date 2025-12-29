import 'package:get_it/get_it.dart';
import 'package:sana/core/services/sharedpref/shared_pref.dart';
import 'package:sana/features/asma_ul_husna/presentation/cubit/asma_ul_husna_cubit.dart';
import 'package:sana/features/salat_ala_Nabi/data/repo/reminder_repo.dart';
import 'package:sana/features/salat_ala_Nabi/presentation/cubit/reminder_cubit.dart';

void setupOtherFeaturesDependencies(GetIt sl) {
  // 1) Asma ul Husna Cubit
  sl.registerFactory<AsmaUlHusnaCubit>(AsmaUlHusnaCubit.new);

  // 2) Reminder (Salat ala Nabi) Repository
  sl.registerLazySingleton(() => ReminderRepo(sharedPref: sl<SharedPref>()));

  // 3) Reminder Cubit
  sl.registerFactory(() => ReminderCubit(sl<ReminderRepo>()));
}
