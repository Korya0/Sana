import 'package:get_it/get_it.dart';
import 'package:sana/core/services/local_storage/local_storage_service.dart';
import 'package:sana/features/prayer/data/repos/prayer_repository.dart';
import 'package:sana/features/prayer/data/services/prayer_state_service.dart';
import 'package:sana/features/prayer/data/services/prayer_status_service.dart';
import 'package:sana/features/prayer/data/services/prayer_times_service.dart';
import 'package:sana/features/prayer/data/services/religious_events_service.dart';
import 'package:sana/features/prayer/data/services/user_settings_service.dart';
import 'package:sana/features/prayer/domain/repos/prayer_repository.dart';
import 'package:sana/features/prayer/presentation/cubits/prayer_times_cubit.dart';

void setupPrayerDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<UserSettingsService>(
      () => UserSettingsServiceImpl(sl()),
    )
    ..registerLazySingleton<ReligiousEventsService>(
      ReligiousEventsServiceImpl.new,
    )
    ..registerLazySingleton<PrayerStateService>(
      () => const PrayerStateServiceImpl(),
    )
    ..registerLazySingleton<PrayerStatusService>(PrayerStatusServiceImpl.new)
    ..registerLazySingleton<PrayerTimesService>(
      () => PrayerTimesServiceImpl(settingsService: sl(), stateService: sl()),
    )
    ..registerLazySingleton<PrayerRepository>(
      () => PrayerRepoImpl(sl<LocalStorageService>()),
    )
    ..registerLazySingleton<PrayerTimesCubit>(
      () => PrayerTimesCubit(
        prayerTimesService: sl<PrayerTimesService>(),
        prayerRepository: sl<PrayerRepository>(),
        settingsService: sl<UserSettingsService>(),
        religiousEventsService: sl<ReligiousEventsService>(),
        prayerStatusService: sl<PrayerStatusService>(),
      ),
    );
}
