import 'package:flutter/foundation.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/features/home/data/models/category_item.dart';
import 'package:solar_icons/solar_icons.dart';

class FeaturesLocalDataSource {
  List<CategoryItem> getFeatures() {
    return kIsWeb
        ? [
            CategoryItem(
              id: 'teaching_prayer',
              title: 'تعلم الصلاة',
              icon: SolarIconsBold.book2,
              route: AppRoutes.teachingPrayer,
            ),

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
              id: 'hadith_search',
              title: AppStrings.hadiths,
              icon: SolarIconsBold.magnifier,
              route: AppRoutes.hadithSearch,
            ),
          ]
        : [
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
              id: 'hadith_search',
              title: 'الأحاديث',
              icon: SolarIconsBold.magnifier,
              route: AppRoutes.hadithSearch,
            ),

            CategoryItem(
              id: 'teaching_prayer',
              title: 'تعلم الصلاة',
              icon: SolarIconsBold.book2,
              route: AppRoutes.teachingPrayer,
            ),

            CategoryItem(
              id: 'asma_ul_husna',
              title: 'الأسماء الحسنى',
              icon: FlutterIslamicIcons.solidAllah,
              route: AppRoutes.asmaUlHusna,
            ),
          ];
  }
}
