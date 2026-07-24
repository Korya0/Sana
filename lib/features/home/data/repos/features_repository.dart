import 'dart:async';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/error/error.dart';
import 'package:sana/core/network/result.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/home/data/data_sources/features_local_data_source.dart';

abstract interface class FeaturesRepository {
  Result<List<String>> getFeatures();
}

class FeaturesRepoImpl implements FeaturesRepository {
  FeaturesRepoImpl(this._dataSource);
  final FeaturesLocalDataSource _dataSource;

  @override
  Result<List<String>> getFeatures() {
    try {
      final items = _dataSource.getFeatures();
      return Result.success(items);
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.error(
          'GetFeatures Error',
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
