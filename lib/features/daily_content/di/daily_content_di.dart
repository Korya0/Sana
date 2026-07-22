import 'package:get_it/get_it.dart';
import 'package:sana/features/app_date/presentation/cubit/app_date_cubit.dart';
import 'package:sana/core/services/local_storage/i_local_storage_service.dart';
import 'package:sana/features/daily_content/data/datasources/daily_content_datasource.dart';
import 'package:sana/features/daily_content/data/repos/daily_content_repository.dart';
import 'package:sana/features/daily_content/data/services/daily_content_favorites_service.dart';
import 'package:sana/features/daily_content/data/services/daily_content_shuffle_service.dart';
import 'package:sana/features/daily_content/presentation/cubit/daily_content_cubit.dart';
import 'package:sana/features/daily_content/presentation/cubit/daily_favorites_cubit.dart';

void setupDailyContentDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<IDailyContentDataSource>(
      DailyContentDataSourceImpl.new,
    )
    ..registerLazySingleton<DailyContentShuffleService>(
      () => DailyContentShuffleService(
        localStorageService: sl<ILocalStorageService>(),
      ),
    )
    ..registerLazySingleton<DailyContentFavoritesService>(
      () => DailyContentFavoritesService(
        localStorageService: sl<ILocalStorageService>(),
      ),
    )
    ..registerLazySingleton<IDailyContentRepository>(
      () => DailyContentRepoImpl(
        sl<IDailyContentDataSource>(),
        sl<DailyContentShuffleService>(),
        sl<DailyContentFavoritesService>(),
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
