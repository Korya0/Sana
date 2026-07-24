import 'package:get_it/get_it.dart';
import 'package:sana/core/services/local_storage/local_storage_service.dart';
import 'package:sana/features/salat_ala_nabi/data/data_sources/reminder_local_data_source.dart';
import 'package:sana/features/salat_ala_nabi/data/repos/reminder_repo.dart';
import 'package:sana/features/salat_ala_nabi/data/services/salawat_reminder_service.dart';
import 'package:sana/features/salat_ala_nabi/domain/repos/reminder_repo.dart';
import 'package:sana/features/salat_ala_nabi/domain/repos/salawat_reminder_service.dart';
import 'package:sana/features/salat_ala_nabi/presentation/cubits/reminder_cubit.dart';

void setupSalatAlaNabiDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<ReminderLocalDataSource>(
      () => ReminderLocalDataSourceImpl(sl<LocalStorageService>()),
    )
    ..registerLazySingleton<ReminderRepository>(
      () => ReminderRepositoryImpl(
        localDataSource: sl<ReminderLocalDataSource>(),
      ),
    )
    ..registerLazySingleton<SalawatReminderService>(
      () => SalawatReminderServiceImpl(sl(), sl()),
    )
    ..registerFactory<ReminderCubit>(
      () => ReminderCubit(
        sl<ReminderRepository>(),
        sl<SalawatReminderService>(),
      ),
    );
}
