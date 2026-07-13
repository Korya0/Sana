import 'dart:async';

import 'package:sana/core/error/error.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/azkar/data/datasources/i_azkar_local_data_source.dart';
import 'package:sana/features/azkar/domain/entities/category_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/repositories/i_azkar_repository.dart';

class AzkarRepositoryImpl implements IAzkarRepository {
  AzkarRepositoryImpl(this.localDataSource);

  final IAzkarLocalDataSource localDataSource;
  bool _isReady = false;

  Future<void> _ensureReady() async {
    if (!_isReady) {
      await localDataSource.ensureDatabaseReady();
      _isReady = true;
    }
  }

  @override
  Future<Result<List<CategoryEntity>>> getCategories() async {
    try {
      await _ensureReady();
      final models = await localDataSource.getCategories();
      return Result.success(models);
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.error(
          'AzkarRepository: getCategories failed',
          error: e,
          stackTrace: stack,
        ),
      );
      return const Result.failure(
        CacheFailure(message: 'Failed to load categories'),
      );
    }
  }

  @override
  Future<Result<List<ZikrEntity>>> getAzkarByCategory(int categoryId) async {
    try {
      await _ensureReady();
      final models = await localDataSource.getAzkarByCategory(categoryId);
      return Result.success(models);
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.error(
          'AzkarRepository: getAzkarByCategory failed for $categoryId',
          error: e,
          stackTrace: stack,
        ),
      );
      return const Result.failure(
        CacheFailure(message: 'Failed to load azkar'),
      );
    }
  }
}
