import 'package:get_it/get_it.dart';
import 'package:sana/features/azkar/data/data_sources/azkar_local_data_source.dart';
import 'package:sana/features/azkar/data/data_sources/azkar_local_data_source_impl.dart';
import 'package:sana/features/azkar/data/data_sources/custom_azkar_local_data_source.dart';
import 'package:sana/features/azkar/data/data_sources/custom_azkar_local_data_source_impl.dart';
import 'package:sana/features/azkar/data/data_sources/tasbeeh_local_data_source.dart';
import 'package:sana/features/azkar/data/data_sources/tasbeeh_local_data_source_impl.dart';
import 'package:sana/features/azkar/data/repositories/azkar_repository_impl.dart';
import 'package:sana/features/azkar/data/repositories/custom_azkar_repository_impl.dart';
import 'package:sana/features/azkar/data/repositories/reading_settings_repository_impl.dart';
import 'package:sana/features/azkar/data/repositories/tasbeeh_repository_impl.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_repository.dart';
import 'package:sana/features/azkar/domain/repositories/custom_azkar_repository.dart';
import 'package:sana/features/azkar/domain/repositories/reading_settings_repository.dart';
import 'package:sana/features/azkar/domain/repositories/tasbeeh_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/delete_custom_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/delete_tasbeeh_item_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_by_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_categories_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_custom_categories_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_reading_settings_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_tasbeeh_items_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/save_custom_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/save_tasbeeh_item_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/update_reading_settings_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/categories/azkar_categories_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/custom_azkar/custom_azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/tasbeeh/tasbeeh_cubit.dart';

void setupAzkarDependencies(GetIt sl) {
  sl
    // Data sources
    ..registerLazySingleton<AzkarLocalDataSource>(
      () => const AzkarLocalDataSourceImpl(),
    )
    ..registerLazySingleton<CustomAzkarLocalDataSource>(
      () => CustomAzkarLocalDataSourceImpl(sl(), sl()),
    )
    ..registerLazySingleton<TasbeehLocalDataSource>(
      () => TasbeehLocalDataSourceImpl(sl(), sl()),
    )
    // Repositories
    ..registerLazySingleton<AzkarRepository>(
      () => AzkarRepositoryImpl(sl(), sl(), sl()),
    )
    ..registerLazySingleton<CustomAzkarRepository>(
      () => CustomAzkarRepositoryImpl(sl(), sl()),
    )
    ..registerLazySingleton<ReadingSettingsRepository>(
      () => ReadingSettingsRepositoryImpl(sl(), sl()),
    )
    ..registerLazySingleton<TasbeehRepository>(
      () => TasbeehRepositoryImpl(sl(), sl()),
    )
    // Use cases
    ..registerLazySingleton(() => GetAzkarCategoriesUseCase(sl()))
    ..registerLazySingleton(() => GetCustomCategoriesUseCase(sl()))
    ..registerLazySingleton(() => SaveCustomCategoryUseCase(sl()))
    ..registerLazySingleton(() => DeleteCustomCategoryUseCase(sl()))
    ..registerLazySingleton(() => GetAzkarByCategoryUseCase(sl()))
    ..registerLazySingleton(() => GetReadingSettingsUseCase(sl()))
    ..registerLazySingleton(() => UpdateReadingSettingsUseCase(sl()))
    ..registerLazySingleton(() => GetTasbeehItemsUseCase(sl()))
    ..registerLazySingleton(() => SaveTasbeehItemUseCase(sl()))
    ..registerLazySingleton(() => DeleteTasbeehItemUseCase(sl()))
    // Cubits
    ..registerFactory(() => AzkarCategoriesCubit(sl(), sl()))
    ..registerFactory(
      () => CustomAzkarCubit(
        getCustomCategoriesUseCase: sl(),
        saveCustomCategoryUseCase: sl(),
        deleteCustomCategoryUseCase: sl(),
        getAzkarCategoriesUseCase: sl(),
      ),
    )
    ..registerFactory(() => AzkarCubit(sl(), sl(), sl(), sl()))
    ..registerFactory(() => ReadingSettingsCubit(sl(), sl()))
    ..registerFactory(() => TasbeehCubit(sl(), sl(), sl()));
}
