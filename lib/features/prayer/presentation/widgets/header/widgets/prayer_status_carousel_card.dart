import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/features/prayer/data/constants/prayer_strings.dart';
import 'package:sana/features/prayer/data/models/prayer_time_status.dart';
import 'package:sana/features/prayer/presentation/widgets/header/widgets/prayer_status_details_dialog.dart';

class PrayerStatusCarouselCard extends StatelessWidget {
  const PrayerStatusCarouselCard({
    required this.status,
    super.key,
  });

  final PrayerTimeStatus status;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showStatusDialog(context),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                status.status,
                style: AppTextStyles.font18W700Gold(
                  context,
                ).copyWith(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                PrayerStrings.tapToKnowVirtue,
                style: AppTextStyles.font12W500White(context).copyWith(
                  color: Colors.white.withAlpha(153),
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showStatusDialog(BuildContext context) {
    PrayerStatusDetailsDialog.show(context, status);
  }
}
