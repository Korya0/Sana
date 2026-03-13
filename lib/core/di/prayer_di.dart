import 'package:get_it/get_it.dart';
import 'package:sana/core/services/local_storage/local_storage_service.dart';
import 'package:sana/features/app_date/presentation/controller/app_date_cubit.dart';
import 'package:sana/features/location_manager/presentation/controller/location_permission/location_cubit.dart';
import 'package:sana/features/prayer/data/repositories/prayer_repository.dart';
import 'package:sana/features/prayer/data/services/prayer_state_service.dart';
import 'package:sana/features/prayer/data/services/prayer_status_service.dart';
import 'package:sana/features/prayer/data/services/prayer_times_service.dart';
import 'package:sana/features/prayer/data/services/religious_events_service.dart';
import 'package:sana/features/prayer/data/services/user_settings_service.dart';
import 'package:sana/features/prayer/presentation/controller/prayer_times_cubit.dart';

void setupPrayerDependencies(GetIt sl) {
  // 1) UserSettingsService
  sl
    ..registerLazySingleton<UserSettingsService>(
      () => UserSettingsService(sl()),
    )
    // 2) ReligiousEventsService
    ..registerLazySingleton<ReligiousEventsService>(
      ReligiousEventsService.new,
    )
    // 3) PrayerStateService
    ..registerLazySingleton<PrayerStateService>(
      () => const PrayerStateService(),
    )
    // 4) PrayerStatusService
    ..registerLazySingleton<PrayerStatusService>(
      PrayerStatusService.new,
    )
    // 5) PrayerTimesService
    ..registerLazySingleton<PrayerTimesService>(
      () => PrayerTimesService(
        settingsService: sl(),
        stateService: sl(),
      ),
    )
    // 5) PrayerRepository
    ..registerLazySingleton<IPrayerRepository>(
      () => PrayerRepository(sl<ILocalStorageService>()),
    )
    // 6) PrayerTimesCubit
    ..registerLazySingleton<PrayerTimesCubit>(
      () => PrayerTimesCubit(
        prayerTimesService: sl<PrayerTimesService>(),
        prayerRepository: sl<IPrayerRepository>(),
        settingsService: sl<UserSettingsService>(),
        appDateCubit: sl<AppDateCubit>(),
        locationCubit: sl<LocationCubit>(),
        religiousEventsService: sl<ReligiousEventsService>(),
        prayerStatusService: sl<PrayerStatusService>(),
      ),
    );
}
