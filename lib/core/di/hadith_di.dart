import 'package:get_it/get_it.dart';
import 'package:sana/features/hadith_search/data/data_sources/hadith_remote_data_source.dart';
import 'package:sana/features/hadith_search/data/repositories/hadith_favorites_repository.dart';
import 'package:sana/features/hadith_search/data/repositories/hadith_repository_impl.dart';
import 'package:sana/features/hadith_search/domain/repositories/hadith_repository.dart';
import 'package:sana/features/hadith_search/domain/repositories/i_hadith_favorites_repository.dart';
import 'package:sana/features/hadith_search/domain/use_cases/search_hadith_use_case.dart';
import 'package:sana/features/hadith_search/presentation/controller/hadith_favorites/hadith_favorites_cubit.dart';
import 'package:sana/features/hadith_search/presentation/controller/hadith_search/hadith_search_cubit.dart';

void setupHadithDependencies(GetIt sl) {
  // Data Source
  sl
    ..registerLazySingleton<HadithRemoteDataSource>(
      () => HadithRemoteDataSourceImpl(sl()),
    )
    // Repository
    ..registerLazySingleton<HadithRepository>(() => HadithRepositoryImpl(sl()))
    ..registerLazySingleton<IHadithFavoritesRepository>(
      () => HadithFavoritesRepository(sl()),
    )
    // Use Case
    ..registerLazySingleton<SearchHadithUseCase>(
      () => SearchHadithUseCase(sl()),
    )
    // Cubit
    ..registerFactory<HadithCubit>(() => HadithCubit(sl()))
    ..registerLazySingleton<HadithFavoritesCubit>(
      () => HadithFavoritesCubit(sl()),
    );
}
