import 'package:get_it/get_it.dart';
import 'package:sana/features/azkar/data/datasources/azkar_local_data_source.dart';
import 'package:sana/features/azkar/data/repositories/azkar_repository.dart';
import 'package:sana/features/azkar/presentation/controller/azkar_categories_cubit.dart';
import 'package:sana/features/azkar/presentation/controller/azkar_category_loader_cubit.dart';

/// Setup Azkar dependencies
void setupAzkarDependencies(GetIt sl) {
  sl
    // 1) DataSources
    ..registerLazySingleton<AzkarLocalDataSource>(AzkarLocalDataSource.new)
    // 2) Repositories
    ..registerLazySingleton<IAzkarRepository>(
      () => AzkarRepository(sl<AzkarLocalDataSource>()),
    )
    // 3) Cubits — registered as Factory (new instance per use)
    ..registerFactory<AzkarCategoriesCubit>(
      () => AzkarCategoriesCubit(sl<IAzkarRepository>()),
    )
    ..registerFactory<AzkarCategoryLoaderCubit>(
      () => AzkarCategoryLoaderCubit(sl<IAzkarRepository>()),
    );
}
