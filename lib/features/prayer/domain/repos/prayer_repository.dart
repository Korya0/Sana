import 'package:sana/features/prayer/domain/entities/prayer_times_entity.dart';
import 'package:sana/features/prayer/domain/entities/user_prayer_times_settings_entity.dart';
import 'package:sana/core/network/result.dart';

/// واجهة مستودع بيانات الصلاة.
/// تقوم الواجهة بجلب الإحداثيات والإعدادات داخلياً دون إفصاح عن
/// تفاصيل التنفيذ لطبقة الـ Presentation.
abstract interface class PrayerRepository {
  /// يُرجع مواقيت الصلاة بناءً على الإعدادات والإحداثيات المخزنة.
  Result<PrayerTimesEntity> getPrayerTimes({
    required UserPrayerTimesSettings settings,
    required DateTime dateTime,
  });
}
