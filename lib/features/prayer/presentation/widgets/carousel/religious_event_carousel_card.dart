import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/features/prayer/data/services/religious_events_service.dart';
import 'package:sana/features/prayer/presentation/prayer_strings.dart';
import 'package:sana/features/prayer/presentation/widgets/carousel/prayer_status_details_dialog.dart';

class ReligiousEventCarouselCard extends StatelessWidget {
  const ReligiousEventCarouselCard({
    required this.event,
    this.isToday = true,
    super.key,
  });

  final ReligiousEventModel event;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showHadithDialog(context),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isToday
                    ? PrayerStrings.eventToday
                    : PrayerStrings.upcomingEvent,
                style: AppTextStyles.font14W400Gold(
                  context,
                ).copyWith(fontSize: 12),
              ),
              const SizedBox(height: 2),
              Text(
                event.displayName,
                style: AppTextStyles.font16W700White(
                  context,
                ).copyWith(fontSize: 15),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 2),
              Text(
                'اضغط لمعرفة الفضل',
                style: AppTextStyles.font12W500White(context).copyWith(
                  color: Colors.white.withAlpha(153),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHadithDialog(BuildContext context) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (context) => PrayerStatusDetailsDialog(
          title: 'فضل ${event.displayName}',
          content: event.hadithText ?? 'لا يوجد نص فضل متاح حالياً.',
          source: event.bookInfo,
          categoryLabel: 'حديث نبوي',
        ),
      ),
    );
  }
}
