import 'dart:async';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/error/error.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/home/data/datasources/i_features_local_data_source.dart';
import 'package:sana/features/home/data/models/category_item.dart';

abstract class IFeaturesRepository {
  Result<List<CategoryItem>> getFeatures();
}

class FeaturesRepoImpl implements IFeaturesRepository {
  FeaturesRepoImpl(this._dataSource);
  final IFeaturesLocalDataSource _dataSource;

  @override
  Result<List<CategoryItem>> getFeatures() {
    try {
      final items = _dataSource.getFeatures();
      return Result.success(items);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.reportToFirebase('GetFeatures Error', error: e, stackTrace: stack),
      );
      return const Result.failure(
        CacheFailure(
          message: AppStrings.ourFault,
        ),
      );
    }
  }
}
