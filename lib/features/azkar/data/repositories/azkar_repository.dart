import 'dart:async';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/networking/api_result.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/azkar/data/datasources/azkar_local_data_source.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';

abstract class IAzkarRepository {
  Future<ApiResult<List<AzkarCategoryModel>>> getAllCategories();
  Future<ApiResult<AzkarCategoryModel>> getItemById(String id);
}

class AzkarRepository implements IAzkarRepository {
  AzkarRepository(this._dataSource);
  final AzkarLocalDataSource _dataSource;

  @override
  Future<ApiResult<List<AzkarCategoryModel>>> getAllCategories() async {
    try {
      final items = await _dataSource.getAllCategories();
      if (items.isEmpty) {
        return const ApiResult.failure(
          Failure.missingData(message: AppStrings.missingDataError),
        );
      }
      return ApiResult.success(items);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error('GetAllCategories Error', error: e, stackTrace: stack),
      );
      return const ApiResult.failure(
        Failure.cache(
          message: AppStrings.ourFault,
        ),
      );
    }
  }

  @override
  Future<ApiResult<AzkarCategoryModel>> getItemById(String id) async {
    try {
      final result = await getAllCategories();
      return result.when(
        success: (categories) {
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
            return const ApiResult.failure(
              Failure.missingData(message: AppStrings.missingDataError),
            );
          }
        },
        failure: ApiResult.failure,
      );
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error('GetItemById Main Error', error: e, stackTrace: stack),
      );
      return const ApiResult.failure(
        Failure.cache(
          message: AppStrings.ourFault,
        ),
      );
    }
  }
}
