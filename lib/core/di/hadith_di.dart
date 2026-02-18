import 'package:get_it/get_it.dart';
import 'package:sana/features/hadith_search/data/data_sources/hadith_remote_data_source.dart';
import 'package:sana/features/hadith_search/data/repositories/hadith_favorites_repository.dart';
import 'package:sana/features/hadith_search/data/repositories/hadith_repository_impl.dart';
import 'package:sana/features/hadith_search/domain/repositories/hadith_repository.dart';
import 'package:sana/features/hadith_search/domain/use_cases/search_hadith_use_case.dart';
import 'package:sana/features/hadith_search/presentation/controller/hadith_favorites/hadith_favorites_cubit.dart';
import 'package:sana/features/hadith_search/presentation/controller/hadith_search/hadith_search_cubit.dart';

void setupHadithDependencies(GetIt sl) {
  // Data Source
  sl.registerLazySingleton<HadithRemoteDataSource>(
    () => HadithRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<HadithRepository>(() => HadithRepositoryImpl(sl()));
  sl.registerLazySingleton<HadithFavoritesRepository>(
    () => HadithFavoritesRepository(sl()),
  );

  // Use Case
  sl.registerLazySingleton<SearchHadithUseCase>(
    () => SearchHadithUseCase(sl()),
  );

  // Cubit
  sl.registerFactory<HadithCubit>(() => HadithCubit(sl()));
  sl.registerFactory<HadithFavoritesCubit>(() => HadithFavoritesCubit(sl()));
}
