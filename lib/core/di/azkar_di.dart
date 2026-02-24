import 'package:get_it/get_it.dart';
import 'package:sana/features/azkar/data/datasource/azkar_local_data_source.dart';
import 'package:sana/features/azkar/data/repositories/azkar_repository.dart';
import 'package:sana/features/azkar/presentation/controller/azkar_categories_cubit.dart';
import 'package:sana/features/azkar/presentation/controller/azkar_category_loader_cubit.dart';
import 'package:sana/features/home/data/datasources/features_local_data_source.dart';
import 'package:sana/features/home/data/repositories/features_repository.dart';
import 'package:sana/features/home/presentation/controller/features_list_cubit.dart';

/// Setup Azkar and Features dependencies
void setupAzkarDependencies(GetIt sl) {
  // 1) DataSources
  sl
    ..registerLazySingleton<AzkarLocalDataSource>(AzkarLocalDataSource.new)
    ..registerLazySingleton<FeaturesLocalDataSource>(
      FeaturesLocalDataSource.new,
    )
    // 2) Repositories
    // Azkar Repository
    ..registerLazySingleton<IAzkarRepository>(
      () => AzkarRepository(sl<AzkarLocalDataSource>()),
    )
    // Features Repository
    ..registerLazySingleton<IFeaturesRepository>(
      () => FeaturesRepository(sl<FeaturesLocalDataSource>()),
    )
    // 3) Cubits
    // Azkar Categories Cubit
    ..registerFactory<AzkarCategoriesCubit>(
      () => AzkarCategoriesCubit(sl<IAzkarRepository>()),
    )
    // Features List Cubit
    ..registerFactory<FeaturesListCubit>(
      () => FeaturesListCubit(sl<IFeaturesRepository>()),
    )
    // Azkar Category Loader Cubit (Single Item)
    ..registerFactory<AzkarCategoryLoaderCubit>(
      () => AzkarCategoryLoaderCubit(sl<IAzkarRepository>()),
    );
}
