import 'package:get_it/get_it.dart';
import 'package:sana/core/services/sharedpref/pref_keys.dart';
import 'package:sana/features/azkar/data/datasource/azkar_local_data_source.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';
import 'package:sana/features/home/data/datasources/features_local_data_source.dart';
import 'package:sana/features/home/data/model/category_item.dart';
import 'package:sana/features/home/data/repositories/sortable_category_repository.dart';
import 'package:sana/features/home/presentation/cubit/sortable_category_cubit.dart';

/// Setup Azkar and Features dependencies
void setupAzkarDependencies(GetIt sl) {
  // 1) DataSources
  sl.registerLazySingleton<AzkarLocalDataSource>(AzkarLocalDataSource.new);
  sl.registerLazySingleton<FeaturesLocalDataSource>(
    FeaturesLocalDataSource.new,
  );

  // 2) Repositories
  // Azkar Categories Repository
  sl.registerLazySingleton<SortableCategoryRepository<AzkarCategoryModel>>(
    () => SortableCategoryRepository<AzkarCategoryModel>(
      dataSourceGetter: () => sl<AzkarLocalDataSource>().getAllCategories(),
      prefKey: PrefKeys.azkarCategoryUsage,
    ),
  );

  // Features Repository
  sl.registerLazySingleton<SortableCategoryRepository<CategoryItem>>(
    () => SortableCategoryRepository<CategoryItem>(
      dataSourceGetter: () async => sl<FeaturesLocalDataSource>().getFeatures(),
      prefKey: PrefKeys.allFeaturesUsage,
    ),
  );

  // 3) Cubits
  // Azkar Categories Cubit
  sl.registerFactory<SortableCategoryCubit<AzkarCategoryModel>>(
    () => SortableCategoryCubit<AzkarCategoryModel>(
      sl<SortableCategoryRepository<AzkarCategoryModel>>(),
    ),
  );

  // Features Cubit
  sl.registerFactory<SortableCategoryCubit<CategoryItem>>(
    () => SortableCategoryCubit<CategoryItem>(
      sl<SortableCategoryRepository<CategoryItem>>(),
    ),
  );
}
