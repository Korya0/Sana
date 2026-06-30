import 'package:get_it/get_it.dart';
import 'package:sana/core/services/local_storage/i_local_storage_service.dart';
import 'package:sana/core/services/time/domain/services/i_midnight_timer_service.dart';
import 'package:sana/features/app_date/data/repositories/app_date_repository.dart';
import 'package:sana/features/app_date/domain/repositories/i_app_date_repository.dart';
import 'package:sana/features/app_date/presentation/cubit/app_date_cubit.dart';

void setupAppDateDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<IAppDateRepository>(
      () => AppDateRepositoryImpl(sl<ILocalStorageService>()),
    )
    ..registerLazySingleton<AppDateCubit>(
      () => AppDateCubit(
        sl<IAppDateRepository>(),
        sl<IMidnightTimerService>(),
      ),
    );
}
