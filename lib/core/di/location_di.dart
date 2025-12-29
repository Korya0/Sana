import 'package:get_it/get_it.dart';
import 'package:sana/core/services/location/controller/location_name/location_name_cubit.dart';
import 'package:sana/core/services/location/data/location_name_service.dart';
import 'package:sana/core/services/location/data/location_repo.dart';
import 'package:sana/core/services/location/data/location_service.dart';
import 'package:sana/core/services/sharedpref/shared_pref.dart';

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
  sl.registerFactory<LocationNameCubit>(
    () => LocationNameCubit(
      service: sl<LocationNameService>(),
      prefs: sl<SharedPref>(),
    ),
  );
}
