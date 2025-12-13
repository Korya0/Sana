import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/features/home/data/model/category_item.dart';
import 'package:solar_icons/solar_icons.dart';

class FeaturesLocalDataSource {
  List<CategoryItem> getFeatures() {
    return [
      CategoryItem(
        id: 'asma_ul_husna',
        title: 'الأسماء الحسنى',
        icon: FlutterIslamicIcons.solidAllah,
        route: AppRoutes.asmaUlHusna,
      ),
      CategoryItem(
        id: 'salawat',
        title: 'الصلاة على النبي ﷺ',
        icon: FlutterIslamicIcons.solidMohammad,
        route: AppRoutes.salatAlaNabi,
      ),
      CategoryItem(
        id: 'qibla',
        title: 'القبلة',
        icon: SolarIconsBold.compass,
        route: AppRoutes.qibla,
      ),
      CategoryItem(
        id: 'teaching_prayer',
        title: 'تعلم الصلاة',
        icon: SolarIconsBold.book2, // Or another suitable icon
        route: AppRoutes.teachingPrayer,
      ),
    ];
  }
}
