import 'package:get_it/get_it.dart';
import 'package:sana/core/services/local_storage/i_local_storage_service.dart';
import 'package:sana/features/prayer/data/repos/prayer_repository.dart';
import 'package:sana/features/prayer/data/services/prayer_state_service.dart';
import 'package:sana/features/prayer/data/services/prayer_status_service.dart';
import 'package:sana/features/prayer/data/services/prayer_times_service.dart';
import 'package:sana/features/prayer/data/services/religious_events_service.dart';
import 'package:sana/features/prayer/data/services/user_settings_service.dart';
import 'package:sana/features/prayer/domain/repos/i_prayer_repository.dart';
import 'package:sana/features/prayer/presentation/cubit/prayer_times_cubit.dart';

void setupPrayerDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<IUserSettingsService>(
      () => UserSettingsServiceImpl(sl()),
    )
    ..registerLazySingleton<IReligiousEventsService>(
      ReligiousEventsServiceImpl.new,
    )
    ..registerLazySingleton<IPrayerStateService>(
      () => const PrayerStateServiceImpl(),
    )
    ..registerLazySingleton<IPrayerStatusService>(PrayerStatusServiceImpl.new)
    ..registerLazySingleton<IPrayerTimesService>(
      () => PrayerTimesServiceImpl(settingsService: sl(), stateService: sl()),
    )
    ..registerLazySingleton<IPrayerRepository>(
      () => PrayerRepoImpl(sl<ILocalStorageService>()),
    )
    ..registerLazySingleton<PrayerTimesCubit>(
      () => PrayerTimesCubit(
        prayerTimesService: sl<IPrayerTimesService>(),
        prayerRepository: sl<IPrayerRepository>(),
        settingsService: sl<IUserSettingsService>(),
        religiousEventsService: sl<IReligiousEventsService>(),
        prayerStatusService: sl<IPrayerStatusService>(),
      ),
    );
}
