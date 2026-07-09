import 'package:get_it/get_it.dart';
import 'package:sana/features/azkar/data/datasources/azkar_local_data_source_impl.dart';
import 'package:sana/features/azkar/data/datasources/i_azkar_local_data_source.dart';
import 'package:sana/features/azkar/data/repositories/azkar_repository_impl.dart';
import 'package:sana/features/azkar/data/repositories/reading_settings_repository_impl.dart';
import 'package:sana/features/azkar/domain/repositories/i_azkar_repository.dart';
import 'package:sana/features/azkar/domain/repositories/i_reading_settings_repository.dart';
import 'package:sana/features/azkar/domain/usecases/get_azkar_by_category_usecase.dart';
import 'package:sana/features/azkar/domain/usecases/get_categories_usecase.dart';
import 'package:sana/features/azkar/domain/usecases/get_reading_settings_usecase.dart';
import 'package:sana/features/azkar/domain/usecases/update_reading_settings_usecase.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/categories/azkar_categories_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_cubit.dart';

void setupAzkarDependencies(GetIt sl) {
  sl
    // Data Sources
    ..registerLazySingleton<IAzkarLocalDataSource>(
      AzkarLocalDataSourceImpl.new,
    )
    // Repositories
    ..registerLazySingleton<IAzkarRepository>(
      () => AzkarRepositoryImpl(sl()),
    )
    ..registerLazySingleton<IReadingSettingsRepository>(
      () => ReadingSettingsRepositoryImpl(sl()),
    )
    // UseCases
    ..registerLazySingleton(
      () => GetCategoriesUseCase(sl()),
    )
    ..registerLazySingleton(
      () => GetAzkarByCategoryUseCase(sl()),
    )
    ..registerLazySingleton(
      () => GetReadingSettingsUseCase(sl()),
    )
    ..registerLazySingleton(
      () => UpdateReadingSettingsUseCase(sl()),
    )
    // Cubits
    ..registerFactory(() => AzkarCategoriesCubit(sl()))
    ..registerFactory(() => AzkarCubit(sl()))
    ..registerFactory(() => ReadingSettingsCubit(sl(), sl()));
}
