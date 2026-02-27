import 'package:get_it/get_it.dart';
import 'package:sana/core/services/sharedpref/shared_pref.dart';
import 'package:sana/features/app_date/presentation/controller/app_date_cubit.dart';

import 'package:sana/features/location_manager/presentation/controller/location_permission/location_cubit.dart';
import 'package:sana/features/prayer/data/repositories/prayer_repository.dart';
import 'package:sana/features/prayer/data/services/prayer_times_service.dart';
import 'package:sana/features/prayer/data/services/religious_events_service.dart';
import 'package:sana/features/prayer/data/services/user_settings_service.dart';
import 'package:sana/features/prayer/presentation/controller/prayer_times_cubit.dart';

/// Setup prayer-related dependencies
void setupPrayerDependencies(GetIt sl) {
  // 1) UserSettingsService
  sl
    ..registerLazySingleton<UserSettingsService>(UserSettingsService.new)
    // 2) ReligiousEventsService
    ..registerLazySingleton<ReligiousEventsService>(ReligiousEventsService.new)
    // 2) PrayerTimesService
    ..registerLazySingleton<PrayerTimesService>(PrayerTimesService.new)
    // 3) PrayerRepository
    ..registerLazySingleton<IPrayerRepository>(
      () => PrayerRepository(sl<PrayerTimesService>(), sl<SharedPref>()),
    )
    // 4) PrayerTimesCubit - Singleton to ensure shared state across routes
    ..registerLazySingleton<PrayerTimesCubit>(
      () => PrayerTimesCubit(
        prayerTimesService: sl<PrayerTimesService>(),
        prayerRepository: sl<IPrayerRepository>(),
        settingsService: sl<UserSettingsService>(),
        appDateCubit: sl<AppDateCubit>(),
        locationCubit: sl<LocationCubit>(),
        religiousEventsService: sl<ReligiousEventsService>(),
      ),
    );
}
