import 'package:get_it/get_it.dart';
import 'package:sana/features/app_date/presentation/cubits/app_date_cubit.dart';
import 'package:sana/core/services/local_storage/local_storage_service.dart';
import 'package:sana/features/daily_content/data/data_sources/daily_content_datasource.dart';
import 'package:sana/features/daily_content/data/repos/daily_content_repository.dart';
import 'package:sana/features/daily_content/data/services/daily_content_favorites_service.dart';
import 'package:sana/features/daily_content/data/services/daily_content_shuffle_service.dart';
import 'package:sana/features/daily_content/presentation/cubits/daily_content_cubit.dart';
import 'package:sana/features/daily_content/presentation/cubits/daily_favorites_cubit.dart';

void setupDailyContentDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<DailyContentDataSource>(
      DailyContentDataSourceImpl.new,
    )
    ..registerLazySingleton<DailyContentShuffleService>(
      () => DailyContentShuffleService(
        localStorageService: sl<LocalStorageService>(),
      ),
    )
    ..registerLazySingleton<DailyContentFavoritesService>(
      () => DailyContentFavoritesService(
        localStorageService: sl<LocalStorageService>(),
      ),
    )
    ..registerLazySingleton<DailyContentRepository>(
      () => DailyContentRepoImpl(
        sl<DailyContentDataSource>(),
        sl<DailyContentShuffleService>(),
        sl<DailyContentFavoritesService>(),
      ),
    )
    ..registerLazySingleton<DailyContentCubit>(
      () => DailyContentCubit(
        sl<AppDateCubit>(),
        sl<DailyContentRepository>(),
      ),
    )
    ..registerFactory<DailyFavoritesCubit>(
      () => DailyFavoritesCubit(
        sl<DailyContentRepository>(),
        sl<DailyContentCubit>(),
      ),
    );
}
