import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/azkar/data/data_sources/azkar_local_data_source.dart';
import 'package:sana/features/azkar/domain/entities/category_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_repository.dart';

class AzkarRepositoryImpl implements AzkarRepository {
  AzkarRepositoryImpl(this._localDataSource, this._logger);

  final AzkarLocalDataSource _localDataSource;
  final AppLogger _logger;

  // Loads all categories
  @override
  Future<Result<List<CategoryEntity>>> getCategories() async {
    try {
      final categories = await _localDataSource.getCategories();
      return Result.success(categories);
    } on Object catch (error, stackTrace) {
      _logger.error(
        'AzkarRepository: getCategories failed',
        error: error,
        stackTrace: stackTrace,
      );
      return const Result.failure(
        CacheFailure(message: AppStrings.azkarLoadError),
      );
    }
  }

  // Loads category azkar
  @override
  Future<Result<List<ZikrEntity>>> getAzkarByCategory(int categoryId) async {
    try {
      final azkar = await _localDataSource.getAzkarByCategory(categoryId);
      return Result.success(azkar);
    } on Object catch (error, stackTrace) {
      _logger.error(
        'AzkarRepository: getAzkarByCategory failed for $categoryId',
        error: error,
        stackTrace: stackTrace,
      );
      return const Result.failure(
        CacheFailure(message: AppStrings.azkarLoadError),
      );
    }
  }
}
