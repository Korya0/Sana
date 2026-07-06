import 'package:get_it/get_it.dart';
import 'package:sana/features/app_date/presentation/cubit/app_date_cubit.dart';
import 'package:sana/core/services/local_storage/i_local_storage_service.dart';
import 'package:sana/features/daily_content/data/repos/daily_content_repository.dart';
import 'package:sana/features/daily_content/presentation/cubit/daily_content_cubit.dart';
import 'package:sana/features/daily_content/presentation/cubit/daily_favorites_cubit.dart';

import 'package:sana/features/daily_content/data/datasources/daily_content_datasource.dart';

void setupDailyContentDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<IDailyContentDataSource>(
      DailyContentDataSourceImpl.new,
    )
    ..registerLazySingleton<IDailyContentRepository>(
      () => DailyContentRepoImpl(
        sl<ILocalStorageService>(),
        sl<IDailyContentDataSource>(),
      ),
    )
    ..registerLazySingleton<DailyContentCubit>(
      () => DailyContentCubit(
        sl<AppDateCubit>(),
        sl<IDailyContentRepository>(),
      ),
    )
    ..registerFactory<DailyFavoritesCubit>(
      () => DailyFavoritesCubit(
        sl<IDailyContentRepository>(),
        sl<DailyContentCubit>(),
      ),
    );
}
