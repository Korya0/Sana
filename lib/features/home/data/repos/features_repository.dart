import 'dart:async';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/networking/api_result.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/home/data/datasources/features_local_data_source.dart';
import 'package:sana/features/home/data/models/category_item.dart';

abstract class IFeaturesRepository {
  ApiResult<List<CategoryItem>> getFeatures();
}

class FeaturesRepoImpl implements IFeaturesRepository {
  FeaturesRepoImpl(this._dataSource);
  final FeaturesLocalDataSource _dataSource;

  @override
  ApiResult<List<CategoryItem>> getFeatures() {
    try {
      final items = _dataSource.getFeatures();
      return ApiResult.success(items);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error('GetFeatures Error', error: e, stackTrace: stack),
      );
      return const ApiResult.failure(
        Failure.cache(
          message: AppStrings.ourFault,
        ),
      );
    }
  }
}
