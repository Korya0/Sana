import 'package:get_it/get_it.dart';
import 'package:sana/core/services/local_storage/i_local_storage_service.dart';
import 'package:sana/features/hadith_search/data/datasources/dorar_api_client.dart';
import 'package:sana/features/hadith_search/data/datasources/hadith_remote_data_source.dart';
import 'package:sana/features/hadith_search/data/datasources/i_hadith_remote_data_source.dart';
import 'package:sana/features/hadith_search/data/repos/hadith_favorites_repository.dart';
import 'package:sana/features/hadith_search/data/repos/hadith_repository.dart';
import 'package:sana/features/hadith_search/domain/repos/i_hadith_favorites_repository.dart';
import 'package:sana/features/hadith_search/domain/repos/i_hadith_repository.dart';
import 'package:sana/features/hadith_search/presentation/cubit/hadith_favorites/hadith_favorites_cubit.dart';
import 'package:sana/features/hadith_search/presentation/cubit/hadith_search/hadith_search_cubit.dart';

void setupHadithSearchDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<IHadithRemoteDataSource>(
      () => HadithRemoteDataSource(sl<DorarApiClient>()),
    )
    ..registerLazySingleton<IHadithRepository>(
      () => HadithRepoImpl(sl<IHadithRemoteDataSource>()),
    )
    ..registerLazySingleton<IHadithFavoritesRepository>(
      () => HadithFavoritesRepoImpl(sl<ILocalStorageService>()),
    )
    ..registerFactory<HadithSearchCubit>(
      () => HadithSearchCubit(sl<IHadithRepository>()),
    )
    ..registerFactory<HadithFavoritesCubit>(
      () => HadithFavoritesCubit(sl<IHadithFavoritesRepository>()),
    );
}
