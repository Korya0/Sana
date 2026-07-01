import 'dart:async';

import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/error/error.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/azkar/constants/azkar_keys.dart';
import 'package:sana/features/azkar/data/datasources/i_azkar_local_data_source.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';
import 'package:sana/features/azkar/domain/repos/i_azkar_repository.dart';

class AzkarRepoImpl implements IAzkarRepository {
  AzkarRepoImpl(this._dataSource);
  final IAzkarLocalDataSource _dataSource;

  @override
  Future<Result<List<AzkarCategoryEntity>>> getAllCategories() async {
    try {
      final items = await _dataSource.getAllCategories();
      if (items.isEmpty) {
        return const Result.failure(
          MissingDataFailure(message: AppStrings.missingDataError),
        );
      }

      // Priority IDs for sorting
      const priorityIds = AzkarKeys.priorityCategoryIds;

      final sortedList = <AzkarCategoryEntity>[];
      final othersList = <AzkarCategoryEntity>[];

      // Single pass partitioning for better performance
      final categoryMap = {for (final cat in items) cat.id: cat};

      for (final id in priorityIds) {
        if (categoryMap.containsKey(id)) {
          sortedList.add(categoryMap[id]!);
        }
      }

      for (final cat in items) {
        if (!priorityIds.contains(cat.id)) {
          othersList.add(cat);
        }
      }

      final resultList = [...sortedList, ...othersList];
      return Result.success(resultList);
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.reportToFirebase(
          'GetAllCategories Error: Failed to load or process Azkar JSON',
          error: e,
          stackTrace: stack,
        ),
      );
      return const Result.failure(
        CacheFailure(
          message: AppStrings.ourFault,
        ),
      );
    }
  }

  @override
  Future<Result<AzkarCategoryEntity>> getItemById(String id) async {
    try {
      final result = await getAllCategories();
      return switch (result) {
        Success(data: final categories) => () {
          final matches = categories.where((e) => e.id == id);
          final item = matches.isEmpty ? null : matches.first;
          
          if (item == null) {
            return const Result<AzkarCategoryEntity>.failure(
              MissingDataFailure(message: AppStrings.missingDataError),
            );
          }
          return Result.success(item);
        }(),
        FailureResult(:final failure) => Result<AzkarCategoryEntity>.failure(
          failure,
        ),
      };
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.reportToFirebase(
          'GetItemById Main Error',
          error: e,
          stackTrace: stack,
        ),
      );
      return const Result.failure(
        CacheFailure(
          message: AppStrings.ourFault,
        ),
      );
    }
  }
}
