import 'package:sana/features/home/data/models/category_item.dart';

abstract class IFeaturesLocalDataSource {
  List<CategoryItem> getFeatures();
}
