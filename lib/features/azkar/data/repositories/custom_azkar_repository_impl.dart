import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/azkar/data/data_sources/custom_azkar_local_data_source.dart';
import 'package:sana/features/azkar/data/models/custom_category_model.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/domain/repositories/custom_azkar_repository.dart';

class CustomAzkarRepositoryImpl implements CustomAzkarRepository {
  CustomAzkarRepositoryImpl(this._dataSource, this._logger);

  final CustomAzkarLocalDataSource _dataSource;
  final AppLogger _logger;

  // Loads custom categories
  @override
  Future<Result<List<CustomCategoryEntity>>> getCustomCategories() async {
    try {
      final categories = await _dataSource.getCustomCategories();
      return Result.success(categories);
    } on Object catch (error, stackTrace) {
      _logger.error(
        'CustomAzkarRepository: getCustomCategories failed',
        error: error,
        stackTrace: stackTrace,
      );
      return const Result.failure(
        CacheFailure(message: AppStrings.azkarLoadError),
      );
    }
  }

  // Saves or updates a custom category
  @override
  Future<Result<void>> saveCustomCategory(CustomCategoryEntity category) async {
    try {
      final model = CustomCategoryModel.fromEntity(category);
      await _dataSource.saveCustomCategory(model);
      return const Result.success(null);
    } on Object catch (error, stackTrace) {
      _logger.error(
        'CustomAzkarRepository: saveCustomCategory failed',
        error: error,
        stackTrace: stackTrace,
      );
      return const Result.failure(
        CacheFailure(message: AppStrings.saveSettingsError),
      );
    }
  }

  // Deletes a custom category
  @override
  Future<Result<void>> deleteCustomCategory(String id) async {
    try {
      await _dataSource.deleteCustomCategory(id);
      return const Result.success(null);
    } on Object catch (error, stackTrace) {
      _logger.error(
        'CustomAzkarRepository: deleteCustomCategory failed',
        error: error,
        stackTrace: stackTrace,
      );
      return const Result.failure(
        CacheFailure(message: AppStrings.azkarLoadError),
      );
    }
  }

  // Finds a custom category by id
  @override
  Future<Result<CustomCategoryEntity?>> getCustomCategoryById(String id) async {
    try {
      final category = await _dataSource.getCustomCategoryById(id);
      return Result.success(category);
    } on Object catch (error, stackTrace) {
      _logger.error(
        'CustomAzkarRepository: getCustomCategoryById failed for $id',
        error: error,
        stackTrace: stackTrace,
      );
      return const Result.failure(
        CacheFailure(message: AppStrings.azkarLoadError),
      );
    }
  }
}

