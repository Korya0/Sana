import 'package:sana/features/home/data/datasources/features_local_data_source.dart';
import 'package:sana/features/home/data/model/category_item.dart';

abstract class IFeaturesRepository {
  List<CategoryItem> getFeatures();
}

class FeaturesRepository implements IFeaturesRepository {

  FeaturesRepository(this._dataSource);
  final FeaturesLocalDataSource _dataSource;

  @override
  List<CategoryItem> getFeatures() {
    return _dataSource.getFeatures();
  }
}
