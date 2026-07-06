import 'package:get_it/get_it.dart';

import 'package:sana/features/asma_ul_husna/di/asma_ul_husna_di.dart';
import 'package:sana/features/daily_content/di/daily_content_di.dart';
import 'package:sana/features/developer_dashboard/di/dashboard_di.dart';
import 'package:sana/features/feedback/di/feedback_di.dart';
import 'package:sana/features/home/di/home_di.dart';
import 'package:sana/features/prayer/di/prayer_di.dart';
import 'package:sana/features/qibla/di/qibla_di.dart';
import 'package:sana/features/quran/di/quran_di.dart';
import 'package:sana/features/salat_ala_nabi/di/salat_ala_nabi_di.dart';
import 'package:sana/features/teaching_prayer/di/teaching_prayer_di.dart';
import 'package:sana/features/azkar/di/azkar_di.dart';
import 'package:sana/features/settings/di/settings_di.dart';

void setupFeaturesDependencies(GetIt sl) {
  setupAsmaUlHusnaDependencies(sl);
  setupDailyContentDependencies(sl);
  setupDashboardDependencies(sl);
  setupFeedbackDependencies(sl);
  setupHomeDependencies(sl);
  setupPrayerDependencies(sl);
  setupQiblaDependencies(sl);
  setupQuranDependencies(sl);
  setupSalatAlaNabiDependencies(sl);
  setupTeachingPrayerDependencies(sl);
  setupSettingsDependencies(sl);
  setupAzkarDependencies(sl);
}
