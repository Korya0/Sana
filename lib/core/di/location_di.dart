import 'package:get_it/get_it.dart';
import 'package:sana/core/services/local_storage/local_storage_service.dart';
import 'package:sana/features/location_manager/data/datasources/location_local_data_source.dart';
import 'package:sana/features/location_manager/data/datasources/location_remote_data_source.dart';
import 'package:sana/features/location_manager/data/repositories/location_repository.dart';
import 'package:sana/features/location_manager/presentation/controller/location_name/location_name_cubit.dart';
import 'package:sana/features/location_manager/presentation/controller/location_permission/location_cubit.dart';

/// Setup location-related dependencies
void setupLocationDependencies(GetIt sl) {
  // 1) DataSources
  sl
    ..registerLazySingleton<LocationLocalDataSource>(
      LocationLocalDataSource.new,
    )
    ..registerLazySingleton<LocationRemoteDataSource>(
      () => LocationRemoteDataSource(sl()),
    )
    // 2) Repositories
    ..registerLazySingleton<ILocationRepository>(
      () => LocationRepository(
        localDataSource: sl<LocationLocalDataSource>(),
        remoteDataSource: sl<LocationRemoteDataSource>(),
        sharedPref: sl<ILocalStorageService>(),
      ),
    )
    // 3) Cubits
    ..registerFactory<LocationNameCubit>(
      () => LocationNameCubit(
        repository: sl<ILocationRepository>(),
        prefs: sl<ILocalStorageService>(),
        locationCubit: sl<LocationCubit>(),
      ),
    )
    ..registerLazySingleton<LocationCubit>(
      () => LocationCubit(repository: sl<ILocationRepository>()),
    );
}
