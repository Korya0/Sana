import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/prayer/data/services/religious_events_service.dart';
import 'package:sana/features/prayer/presentation/prayer_strings.dart';
import 'package:sana/features/prayer/presentation/widgets/carousel/prayer_status_details_dialog.dart';

class ReligiousEventCarouselCard extends StatelessWidget {
  const ReligiousEventCarouselCard({
    required this.event,
    super.key,
  });

  final ReligiousEventModel event;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              PrayerStrings.religiousEventTitle,
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
            if (event.hadithText != null) ...[
              const SizedBox(height: 4),
              InkWell(
                onTap: () => _showHadithDialog(context),
                borderRadius: BorderRadius.circular(12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      FlutterIslamicIcons.prayingPerson,
                      size: 14,
                      color: AppColors.gold,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      PrayerStrings.dayVirtue,
                      style: AppTextStyles.font12W500Gold(context),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(اضغط لمعرفة الفضل)',
                      style: AppTextStyles.font12W500White(context).copyWith(
                        color: Colors.white.withAlpha(120),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
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
          content: event.hadithText!,
          source: event.bookInfo,
          categoryLabel: 'حديث نبوي',
        ),
      ),
    );
  }
}
