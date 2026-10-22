import 'package:get_it/get_it.dart';
import 'package:sana/features/azkar/data/data_sources/azkar_local_data_source.dart';
import 'package:sana/features/azkar/data/data_sources/azkar_local_data_source_impl.dart';
import 'package:sana/features/azkar/data/repositories/azkar_repository_impl.dart';
import 'package:sana/features/azkar/data/repositories/reading_settings_repository_impl.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_repository.dart';
import 'package:sana/features/azkar/domain/repositories/reading_settings_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_by_category_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_categories_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_reading_settings_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/update_reading_settings_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/categories/azkar_categories_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_cubit.dart';

void setupAzkarDependencies(GetIt sl) {
  sl
    // Data sources
    ..registerLazySingleton<AzkarLocalDataSource>(
      () => const AzkarLocalDataSourceImpl(),
    )
    // Repositories
    ..registerLazySingleton<AzkarRepository>(
      () => AzkarRepositoryImpl(sl(), sl()),
    )
    ..registerLazySingleton<ReadingSettingsRepository>(
      () => ReadingSettingsRepositoryImpl(sl(), sl()),
    )
    // Use cases
    ..registerLazySingleton(() => GetCategoriesUseCase(sl()))
    ..registerLazySingleton(() => GetAzkarByCategoryUseCase(sl()))
    ..registerLazySingleton(() => GetReadingSettingsUseCase(sl()))
    ..registerLazySingleton(() => UpdateReadingSettingsUseCase(sl()))
    // Cubits
    ..registerFactory(() => AzkarCategoriesCubit(sl()))
    ..registerFactory(() => AzkarCubit(sl(), sl()))
    ..registerFactory(() => ReadingSettingsCubit(sl(), sl()));
}
