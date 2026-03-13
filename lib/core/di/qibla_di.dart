import 'package:get_it/get_it.dart';
import 'package:sana/core/services/local_storage/local_storage_service.dart';
import 'package:sana/features/qibla/data/datasources/qibla_local_data_source.dart';
import 'package:sana/features/qibla/data/repositories/qibla_repository.dart';
import 'package:sana/features/qibla/presentation/controller/qibla_cubit.dart';

/// Setup Qibla-related dependencies
void setupQiblaDependencies(GetIt sl) {
  // 1) Data Sources
  sl
    ..registerLazySingleton<QiblaLocalDataSource>(
      () => QiblaLocalDataSource(sl<ILocalStorageService>()),
    )
    // 2) Repository
    ..registerLazySingleton<IQiblaRepository>(
      () => QiblaRepository(
        localDataSource: sl<QiblaLocalDataSource>(),
      ),
    )
    // 3) Cubit
    ..registerFactory<QiblaCubit>(
      () => QiblaCubit(repository: sl<IQiblaRepository>()),
    );
}
