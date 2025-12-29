import 'package:get_it/get_it.dart';
import 'package:sana/core/services/date_gregorian_and_hijri/cubit/app_date_cubit.dart';
import 'package:sana/core/services/location/cubit/location_permission/location_cubit.dart';
import 'package:sana/core/services/sharedpref/shared_pref.dart';
import 'package:sana/features/prayer/data/services/prayer_times_service.dart';
import 'package:sana/features/prayer/data/services/user_settings_service.dart';
import 'package:sana/features/prayer/presentation/cubit/prayer_times_cubit.dart';

/// Setup prayer-related dependencies
void setupPrayerDependencies(GetIt sl) {
  // 1) UserSettingsService
  sl.registerLazySingleton<UserSettingsService>(UserSettingsService.new);

  // 2) PrayerTimesService
  sl.registerLazySingleton<PrayerTimesService>(
    () => PrayerTimesService(sharedPref: sl<SharedPref>()),
  );

  // 3) PrayerTimesCubit - Factory to allow multiple instances if needed
  sl.registerFactory<PrayerTimesCubit>(
    () => PrayerTimesCubit(
      prayerTimesService: sl<PrayerTimesService>(),
      settingsService: sl<UserSettingsService>(),
      appDateCubit: sl<AppDateCubit>(),
      locationCubit: sl<LocationCubit>(),
    ),
  );
}
