import 'package:get_it/get_it.dart';
import 'package:sana/features/azkar/data/datasources/azkar_local_data_source.dart';
import 'package:sana/features/azkar/data/repos/azkar_repository.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar_categories_cubit.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar_category_loader_cubit.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar_list_cubit.dart';

class AzkarDependencyInjection {
  static void init(GetIt sl) {
    sl
      ..registerLazySingleton<AzkarLocalDataSource>(AzkarLocalDataSource.new)
      ..registerLazySingleton<IAzkarRepository>(
        () => AzkarRepoImpl(sl<AzkarLocalDataSource>()),
      )
      ..registerFactory<AzkarCategoriesCubit>(
        () => AzkarCategoriesCubit(sl<IAzkarRepository>()),
      )
      ..registerFactory<AzkarCategoryLoaderCubit>(
        () => AzkarCategoryLoaderCubit(sl<IAzkarRepository>()),
      )
      ..registerFactory<AzkarListCubit>(
        AzkarListCubit.new,
      );
  }
}
