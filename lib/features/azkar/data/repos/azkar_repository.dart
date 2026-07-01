import 'dart:async';

import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/error/error.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/azkar/constants/azkar_keys.dart';
import 'package:sana/features/azkar/data/datasources/i_azkar_local_data_source.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';

abstract class IAzkarRepository {
  Future<Result<List<AzkarCategoryModel>>> getAllCategories();
  Future<Result<AzkarCategoryModel>> getItemById(String id);
}

class AzkarRepoImpl implements IAzkarRepository {
  AzkarRepoImpl(this._dataSource);
  final IAzkarLocalDataSource _dataSource;

  @override
  Future<Result<List<AzkarCategoryModel>>> getAllCategories() async {
    try {
      final items = await _dataSource.getAllCategories();
      if (items.isEmpty) {
        return const Result.failure(
          MissingDataFailure(message: AppStrings.missingDataError),
        );
      }

      // Priority IDs for sorting
      const priorityIds = AzkarKeys.priorityCategoryIds;

      final sortedList = <AzkarCategoryModel>[];
      final othersList = <AzkarCategoryModel>[];

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
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.localError(
          'GetAllCategories Error',
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
  Future<Result<AzkarCategoryModel>> getItemById(String id) async {
    try {
      final result = await getAllCategories();
      return switch (result) {
        Success(data: final categories) => () {
          final matches = categories.where((e) => e.id == id);
          final item = matches.isEmpty ? null : matches.first;
          
          if (item == null) {
            return const Result<AzkarCategoryModel>.failure(
              MissingDataFailure(message: AppStrings.missingDataError),
            );
          }
          return Result.success(item);
        }(),
        FailureResult(:final failure) => Result<AzkarCategoryModel>.failure(
          failure,
        ),
      };
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.localError(
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
