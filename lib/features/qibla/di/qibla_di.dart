import 'package:get_it/get_it.dart';
import 'package:sana/core/services/local_storage/i_local_storage_service.dart';
import 'package:sana/features/qibla/data/datasources/qibla_local_data_source.dart';
import 'package:sana/features/qibla/data/repos/qibla_repository.dart';
import 'package:sana/features/qibla/data/services/qibla_service.dart';
import 'package:sana/features/qibla/domain/repositories/qibla_repository.dart';
import 'package:sana/features/qibla/domain/use_cases/get_qibla_compass_stream_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/get_qibla_direction_use_case.dart';
import 'package:sana/features/qibla/presentation/cubit/qibla_cubit.dart';

void setupQiblaDependencies(GetIt sl) {
  sl
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
    ..registerLazySingleton<GetQiblaDirectionUseCase>(
      () => GetQiblaDirectionUseCase(sl<IQiblaRepository>()),
    )
    ..registerLazySingleton<GetQiblaCompassStreamUseCase>(
      () => GetQiblaCompassStreamUseCase(
        service: sl<IQiblaService>(),
        repository: sl<IQiblaRepository>(),
      ),
    )
    ..registerFactory<QiblaCubit>(
      () => QiblaCubit(
        getQiblaDirectionUseCase: sl<GetQiblaDirectionUseCase>(),
        getQiblaCompassStreamUseCase: sl<GetQiblaCompassStreamUseCase>(),
        repository: sl<IQiblaRepository>(),
      ),
    );
}
