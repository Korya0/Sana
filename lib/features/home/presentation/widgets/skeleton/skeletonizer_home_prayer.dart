import 'package:sana/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:sana/features/prayer/presentation/models/prayer_display_model.dart';
import 'package:sana/features/prayer/domain/entities/prayer_type.dart';
import 'package:sana/features/prayer/domain/entities/user_prayer_times_settings_entity.dart';
import 'package:sana/features/prayer/presentation/cubit/prayer_times_state.dart';
import 'package:sana/features/prayer/presentation/widgets/header/home_prayer_loaded.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonizerHomePrayer extends StatelessWidget {
  const SkeletonizerHomePrayer({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final dummyState = PrayerTimesLoaded(
      settings: UserPrayerTimesSettings.defaultSettings(),
      prayers: [
        PrayerDisplayModel(
          type: PrayerType.fajr,
          time: now.add(const Duration(hours: 1)),
          displayName: 'الفجر',
          isCurrent: false,
          isNext: true,
        ),
        PrayerDisplayModel(
          type: PrayerType.dhuhr,
          time: now.add(const Duration(hours: 6)),
          displayName: 'الظهر',
          isCurrent: false,
          isNext: false,
        ),
        PrayerDisplayModel(
          type: PrayerType.asr,
          time: now.add(const Duration(hours: 9)),
          displayName: 'العصر',
          isCurrent: false,
          isNext: false,
        ),
        PrayerDisplayModel(
          type: PrayerType.maghrib,
          time: now.add(AppConstants.remoteConfigFetchInterval12h),
          displayName: 'المغرب',
          isCurrent: false,
          isNext: false,
        ),
        PrayerDisplayModel(
          type: PrayerType.isha,
          time: now.add(const Duration(hours: 14)),
          displayName: 'العشاء',
          isCurrent: false,
          isNext: false,
        ),
      ],
    );

    return Skeletonizer(
      child: HomePrayerLoaded(state: dummyState),
    );
  }
}
