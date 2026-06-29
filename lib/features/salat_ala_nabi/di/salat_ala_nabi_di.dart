import 'package:get_it/get_it.dart';
import 'package:sana/core/services/local_storage/i_local_storage_service.dart';
import 'package:sana/core/services/permissions/app_permissions_manager.dart';
import 'package:sana/features/salat_ala_nabi/data/datasources/reminder_local_data_source.dart';
import 'package:sana/features/salat_ala_nabi/data/repos/reminder_repo.dart';
import 'package:sana/features/salat_ala_nabi/data/services/salawat_reminder_service.dart';
import 'package:sana/features/salat_ala_nabi/presentation/cubit/reminder_cubit.dart';

void setupSalatAlaNabiDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<IReminderLocalDataSource>(
      () => ReminderLocalDataSourceImpl(sl<ILocalStorageService>()),
    )
    ..registerLazySingleton<IReminderRepository>(
      () => ReminderRepositoryImpl(
        localDataSource: sl<IReminderLocalDataSource>(),
      ),
    )
    ..registerLazySingleton<ISalawatReminderService>(
      () => SalawatReminderServiceImpl(sl(), sl()),
    )
    ..registerFactory<ReminderCubit>(
      () => ReminderCubit(
        sl<IReminderRepository>(),
        sl<ISalawatReminderService>(),
        sl<IAppPermissionsManager>(),
      ),
    );
}
