import 'package:get_it/get_it.dart';
import 'package:sana/core/services/sharedpref/shared_pref.dart';
import 'package:sana/features/location_manager/data/location_name_service.dart';
import 'package:sana/features/location_manager/data/location_repo.dart';
import 'package:sana/features/location_manager/data/location_service.dart';
import 'package:sana/features/location_manager/presentation/cubit/location_name/location_name_cubit.dart';
import 'package:sana/features/location_manager/presentation/cubit/location_permission/location_cubit.dart';

/// Setup location-related dependencies
void setupLocationDependencies(GetIt sl) {
  // 1) LocationService
  sl.registerLazySingleton<LocationService>(LocationService.new);

  // 2) LocationRepo
  sl.registerLazySingleton<LocationRepo>(
    () => LocationRepoImpl(
      locationService: sl<LocationService>(),
      sharedPref: sl<SharedPref>(),
    ),
  );

  // 3) LocationNameService
  sl.registerLazySingleton<LocationNameService>(LocationNameService.new);

  // 4) LocationNameCubit
  sl.registerLazySingleton<LocationNameCubit>(
    () => LocationNameCubit(
      service: sl<LocationNameService>(),
      prefs: sl<SharedPref>(),
      locationCubit: sl<LocationCubit>(),
    ),
  );

  // 5) LocationCubit (Permissions & Core Location Logic)
  sl.registerLazySingleton<LocationCubit>(
    () => LocationCubit(locationRepo: sl<LocationRepo>()),
  );
}
