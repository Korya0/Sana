import 'package:get_it/get_it.dart';
import 'package:sana/core/services/sharedpref/shared_pref.dart';
import 'package:sana/features/qibla/data/repositories/qibla_repository.dart';
import 'package:sana/features/qibla/presentation/controller/qibla_cubit.dart';

/// Setup Qibla-related dependencies
void setupQiblaDependencies(GetIt sl) {
  // 1) Qibla Repository
  sl
    ..registerLazySingleton<QiblaRepository>(
      () => QiblaRepository(sharedPref: sl<SharedPref>()),
    )
    // 2) Qibla Cubit
    ..registerFactory<QiblaCubit>(() => QiblaCubit(sl<QiblaRepository>()));
}
