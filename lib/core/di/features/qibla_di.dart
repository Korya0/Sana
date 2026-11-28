import 'package:get_it/get_it.dart';
import 'package:sana/features/qibla/data/data_sources/compass_local_data_source.dart';
import 'package:sana/features/qibla/data/data_sources/compass_local_data_source_impl.dart';
import 'package:sana/features/qibla/data/data_sources/location_local_data_source.dart';
import 'package:sana/features/qibla/data/data_sources/location_local_data_source_impl.dart';
import 'package:sana/features/qibla/data/repositories/qibla_repository_impl.dart';
import 'package:sana/features/qibla/domain/repositories/qibla_repository.dart';
import 'package:sana/features/qibla/domain/use_cases/calculate_qibla_direction_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/check_compass_sensor_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/check_location_permission_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/get_compass_stream_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/get_current_location_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/get_location_stream_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/open_app_settings_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/open_location_settings_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/request_location_permission_use_case.dart';
import 'package:sana/features/qibla/presentation/cubits/qibla/qibla_cubit.dart';

void setupQiblaDependencies(GetIt sl) {
  // Data sources
  sl
    ..registerLazySingleton<LocationLocalDataSource>(
      () => LocationLocalDataSourceImpl(sl()),
    )
    ..registerLazySingleton<CompassLocalDataSource>(
      () => CompassLocalDataSourceImpl(),
    )
    // Repository
    ..registerLazySingleton<QiblaRepository>(
      () => QiblaRepositoryImpl(
        sl(),
        sl(),
        sl(),
        sl(),
      ),
    )
    // Use cases
    ..registerLazySingleton(() => CalculateQiblaDirectionUseCase(sl()))
    ..registerLazySingleton(() => CheckCompassSensorUseCase(sl()))
    ..registerLazySingleton(() => CheckLocationPermissionUseCase(sl()))
    ..registerLazySingleton(() => RequestLocationPermissionUseCase(sl()))
    ..registerLazySingleton(() => GetCompassStreamUseCase(sl()))
    ..registerLazySingleton(() => GetLocationStreamUseCase(sl()))
    ..registerLazySingleton(() => GetCurrentLocationUseCase(sl()))
    ..registerLazySingleton(() => OpenAppSettingsUseCase(sl()))
    ..registerLazySingleton(() => OpenLocationSettingsUseCase(sl()))
    // Cubit
    ..registerFactory(
      () => QiblaCubit(
        checkCompassSensor: sl(),
        checkLocationPermission: sl(),
        requestLocationPermission: sl(),
        calculateQiblaDirection: sl(),
        getCompassStream: sl(),
        getLocationStream: sl(),
        openAppSettings: sl(),
        openLocationSettings: sl(),
      ),
    );
}
