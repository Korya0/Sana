import 'package:get_it/get_it.dart';

import 'package:sana/core/di/asma_ul_husna_di.dart';
import 'package:sana/core/di/daily_content_di.dart';
import 'package:sana/core/di/dashboard_di.dart';
import 'package:sana/core/di/feedback_di.dart';
import 'package:sana/core/di/home_di.dart';
import 'package:sana/core/di/prayer_di.dart';
import 'package:sana/core/di/qibla_di.dart';
import 'package:sana/core/di/quran_di.dart';
import 'package:sana/core/di/salat_ala_nabi_di.dart';
import 'package:sana/core/di/teaching_prayer_di.dart';
import 'package:sana/core/di/azkar_di.dart';
import 'package:sana/core/di/settings_di.dart';

Future<void> setupFeaturesDependencies(GetIt sl) async {
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
  await setupAzkarDependencies(sl);
}
