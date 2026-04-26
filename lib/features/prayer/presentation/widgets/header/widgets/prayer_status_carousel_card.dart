import 'package:flutter/material.dart';
import 'package:sana/core/common/overlays/dialog/custom_rich_content_dialog.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/features/daily_content/presentation/widgets/share_card/daily_content_share_card.dart';
import 'package:sana/features/prayer/data/models/prayer_time_status.dart';
import 'package:solar_icons/solar_icons.dart';

class PrayerStatusCarouselCard extends StatelessWidget {
  const PrayerStatusCarouselCard({
    required this.status,
    super.key,
  });

  final PrayerTimeStatus status;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showStatusDialog(context);
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                status.status,
                style: AppTextStyles.font14W700primary(context),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                AppStrings.tapToKnowVirtue,
                style: AppTextStyles.font10W500Grey(context).copyWith(
                  color: Colors.white.withValues(alpha: 0.65),
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
    CustomRichContentDialog.show(
      context,
      title: status.status,
      bodyText: status.description,
      source: status.source,
      showShareButton: true,
      backgroundIcon: SolarIconsBold.starFall,
      shareWidgetToCapture: DailyContentShareCard(
        title: status.status,
        subTitle: status.description,
        source: status.source,
        department: AppStrings.prayerVirtuesDepartment,
      ),
      shareImageName: AppStrings.prayerStatusShareImageName,
    );
  }
}
