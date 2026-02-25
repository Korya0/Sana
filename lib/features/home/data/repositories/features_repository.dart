import 'package:dartz/dartz.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/features/home/data/datasources/features_local_data_source.dart';
import 'package:sana/features/home/data/models/category_item.dart';

abstract class IFeaturesRepository {
  Either<Failure, List<CategoryItem>> getFeatures();
}

class FeaturesRepository implements IFeaturesRepository {
  FeaturesRepository(this._dataSource);
  final FeaturesLocalDataSource _dataSource;

  @override
  Either<Failure, List<CategoryItem>> getFeatures() {
    try {
      final items = _dataSource.getFeatures();
      return Right(items);
    } catch (e) {
      return Left(
        CacheFailure(
          message: 'حدث خطأ أثناء تحميل القائمة',
          technicalMessage: e.toString(),
        ),
      );
    }
  }
}
