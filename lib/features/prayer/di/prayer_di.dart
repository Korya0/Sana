import 'package:get_it/get_it.dart';
import 'package:sana/core/services/local_storage/local_storage_service.dart';
import 'package:sana/features/app_date/presentation/controller/app_date_cubit.dart';
import 'package:sana/features/location_manager/presentation/controller/location_permission/location_cubit.dart';
import 'package:sana/features/prayer/data/repos/prayer_repository.dart';
import 'package:sana/features/prayer/data/services/prayer_state_service.dart';
import 'package:sana/features/prayer/data/services/prayer_status_service.dart';
import 'package:sana/features/prayer/data/services/prayer_times_service.dart';
import 'package:sana/features/prayer/data/services/religious_events_service.dart';
import 'package:sana/features/prayer/data/services/user_settings_service.dart';
import 'package:sana/features/prayer/presentation/cubit/prayer_times_cubit.dart';

class PrayerDependencyInjection {
  static void init(GetIt sl) {
    // Services
    sl
      ..registerLazySingleton<UserSettingsService>(
        () => UserSettingsService(sl()),
      )
      ..registerLazySingleton<ReligiousEventsService>(
        ReligiousEventsService.new,
      )
      ..registerLazySingleton<PrayerStateService>(
        () => const PrayerStateService(),
      )
      ..registerLazySingleton<PrayerStatusService>(PrayerStatusService.new)
      ..registerLazySingleton<PrayerTimesService>(
        () => PrayerTimesService(settingsService: sl(), stateService: sl()),
      )
      // Repository
      ..registerLazySingleton<IPrayerRepository>(
        () => PrayerRepoImpl(sl<ILocalStorageService>()),
      )
      // Cubit
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
}
