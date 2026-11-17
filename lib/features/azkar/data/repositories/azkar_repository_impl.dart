import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/azkar/data/data_sources/azkar_local_data_source.dart';
import 'package:sana/features/azkar/data/data_sources/custom_category_local_data_source.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_repository.dart';

class AzkarRepositoryImpl implements AzkarRepository {
  // Creates repository
  AzkarRepositoryImpl(
    this._localDataSource,
    this._logger, [
    this._customDataSource,
  ]);

  final AzkarLocalDataSource _localDataSource;
  final AppLogger _logger;
  final CustomCategoryLocalDataSource? _customDataSource;

  // Loads categories
  @override
  Future<Result<List<AzkarCategoryEntity>>> getCategories() async {
    try {
      final categories = await _localDataSource.getCategories();
      return Result.success(<AzkarCategoryEntity>[...categories]);
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

  // Loads azkar
  @override
  Future<Result<List<ZikrEntity>>> getZikrsByCategory(
    String categoryKey,
  ) async {
    try {
      if (_customDataSource != null) {
        final custom = await _customDataSource.getCustomCategoryById(
          categoryKey,
        );
        if (custom != null) {
          return Result.success(<ZikrEntity>[...custom.azkar]);
        }
      }

      final azkar = await _localDataSource.getZikrsByCategory(categoryKey);
      return Result.success(<ZikrEntity>[...azkar]);
    } on Object catch (error, stackTrace) {
      _logger.error(
        'AzkarRepository: getZikrsByCategory failed for $categoryKey',
        error: error,
        stackTrace: stackTrace,
      );
      return const Result.failure(
        CacheFailure(message: AppStrings.azkarLoadError),
      );
    }
  }
}
