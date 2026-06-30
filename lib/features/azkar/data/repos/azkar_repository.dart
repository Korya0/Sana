import 'dart:async';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/error/error.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/core/utils/utils.dart';
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
      return Result.success(items);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.localError('GetAllCategories Error', error: e, stackTrace: stack),
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
          try {
            final item = categories.firstWhere((e) => e.id == id);
            return Result.success(item);
          } on Exception catch (e, stack) {
            unawaited(
              AppLogger.localError(
                'ItemById Filter Error',
                error: e,
                stackTrace: stack,
              ),
            );
            return const Result<AzkarCategoryModel>.failure(
              MissingDataFailure(message: AppStrings.missingDataError),
            );
          }
        }(),
        FailureResult(:final failure) => Result<AzkarCategoryModel>.failure(
          failure,
        ),
      };
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.localError('GetItemById Main Error', error: e, stackTrace: stack),
      );
      return const Result.failure(
        CacheFailure(
          message: AppStrings.ourFault,
        ),
      );
    }
  }
}
