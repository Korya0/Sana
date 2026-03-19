import 'package:get_it/get_it.dart';
import 'package:sana/core/services/local_storage/local_storage_service.dart';
import 'package:sana/features/app_date/presentation/controller/app_date_cubit.dart';
import 'package:sana/features/asma_ul_husna/data/repos/asma_ul_husna_repository.dart';
import 'package:sana/features/daily_content/data/repos/daily_content_repository.dart';
import 'package:sana/features/daily_content/presentation/cubit/daily_content_cubit.dart';

class DailyContentDependencyInjection {
  static void init(GetIt sl) {
    sl
      ..registerLazySingleton<IDailyContentRepository>(
        () => DailyContentRepoImpl(sl<ILocalStorageService>()),
      )
      ..registerLazySingleton<DailyContentCubit>(
        () => DailyContentCubit(
          sl<AppDateCubit>(),
          sl<IDailyContentRepository>(),
          sl<IAsmaUlHusnaRepository>(),
        ),
      );
  }
}
