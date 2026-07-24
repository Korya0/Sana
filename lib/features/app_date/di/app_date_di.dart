import 'package:get_it/get_it.dart';
import 'package:sana/core/services/local_storage/local_storage_service.dart';
import 'package:sana/core/services/timer/midnight_timer_service.dart';
import 'package:sana/features/app_date/data/repositories/app_date_repository.dart';
import 'package:sana/features/app_date/presentation/cubits/app_date_cubit.dart';

void setupAppDateDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<AppDateRepository>(
      () => AppDateRepositoryImpl(sl<LocalStorageService>()),
    )
    ..registerLazySingleton<AppDateCubit>(
      () => AppDateCubit(
        sl<AppDateRepository>(),
        sl<MidnightTimerService>(),
      )..init(),
    );
}
