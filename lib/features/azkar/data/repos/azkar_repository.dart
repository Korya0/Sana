import 'dart:async';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/error/error.dart';
import 'package:sana/core/networking/api_result.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/azkar/data/datasources/azkar_local_data_source.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';

abstract class IAzkarRepository {
  Future<ApiResult<List<AzkarCategoryModel>>> getAllCategories();
  Future<ApiResult<AzkarCategoryModel>> getItemById(String id);
}

class AzkarRepoImpl implements IAzkarRepository {
  AzkarRepoImpl(this._dataSource);
  final AzkarLocalDataSource _dataSource;

  @override
  Future<ApiResult<List<AzkarCategoryModel>>> getAllCategories() async {
    try {
      final items = await _dataSource.getAllCategories();
      if (items.isEmpty) {
        return const ApiResult.failure(
          MissingDataFailure(message: AppStrings.missingDataError),
        );
      }
      return ApiResult.success(items);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error('GetAllCategories Error', error: e, stackTrace: stack),
      );
      return const ApiResult.failure(
        CacheFailure(
          message: AppStrings.ourFault,
        ),
      );
    }
  }

  @override
  Future<ApiResult<AzkarCategoryModel>> getItemById(String id) async {
    try {
      final result = await getAllCategories();
      return switch (result) {
        Success(data: final categories) => () {
          try {
            final item = categories.firstWhere((e) => e.id == id);
            return ApiResult.success(item);
          } on Exception catch (e, stack) {
            unawaited(
              AppLogger.error(
                'ItemById Filter Error',
                error: e,
                stackTrace: stack,
              ),
            );
            return const ApiResult<AzkarCategoryModel>.failure(
              MissingDataFailure(message: AppStrings.missingDataError),
            );
          }
        }(),
        ApiFailure(:final failure) => ApiResult<AzkarCategoryModel>.failure(
          failure,
        ),
      };
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error('GetItemById Main Error', error: e, stackTrace: stack),
      );
      return const ApiResult.failure(
        CacheFailure(
          message: AppStrings.ourFault,
        ),
      );
    }
  }
}
