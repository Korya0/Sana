import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:sana/features/home/data/datasources/i_features_local_data_source.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/features/home/data/models/category_item.dart';
import 'package:solar_icons/solar_icons.dart';

class FeaturesLocalDataSource implements IFeaturesLocalDataSource {
  @override
  List<CategoryItem> getFeatures() {
    return [
      const CategoryItem(
        id: 'salawat',
        title: AppStrings.salawat,
        icon: FlutterIslamicIcons.solidMohammad,
        route: AppRoutes.salatAlaNabi,
      ),
      const CategoryItem(
        id: 'asma_ul_husna',
        title: AppStrings.asmaUlHusnaHome,
        icon: FlutterIslamicIcons.solidAllah,
        route: AppRoutes.asmaUlHusna,
      ),
      const CategoryItem(
        id: 'teaching_prayer',
        title: AppStrings.teachPrayer,
        icon: SolarIconsBold.book2,
        route: AppRoutes.teachingPrayer,
      ),
      const CategoryItem(
        id: 'qibla',
        title: AppStrings.qibla,
        icon: SolarIconsBold.compass,
        route: AppRoutes.qibla,
      ),
    ];
  }
}
