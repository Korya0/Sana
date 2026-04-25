import 'package:flutter/material.dart';
import 'package:sana/core/common/overlays/dialog/custom_rich_content_dialog.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/features/daily_content/presentation/widgets/share_card/daily_content_share_card.dart';
import 'package:sana/features/prayer/data/models/religious_event_model.dart';
import 'package:solar_icons/solar_icons.dart';

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
    return GestureDetector(
      onTap: () => _showEventDialog(context),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isToday ? AppStrings.eventToday : AppStrings.upcomingEvent,
                style: AppTextStyles.font14W700primary(context),
              ),
              const SizedBox(height: 2),
              Text(
                event.displayName,
                style: AppTextStyles.font18W700primary(
                  context,
                ).copyWith(fontSize: 14),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                AppStrings.tapToKnowVirtue,
                style: AppTextStyles.font12W500Grey(context),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEventDialog(BuildContext context) {
    CustomRichContentDialog.show(
      context,
      title: event.displayName,
      bodyText: event.hadithText ?? AppStrings.noVirtueAvailable,
      source: event.bookInfo,
      showShareButton: true,
      backgroundIcon: SolarIconsBold.starFall,
      shareWidgetToCapture: DailyContentShareCard(
        title: event.displayName,
        subTitle: event.hadithText ?? AppStrings.noVirtueAvailable,
        source: event.bookInfo,
        department: AppStrings.religiousEventsDepartment,
      ),
      shareImageName: AppStrings.prayerStatusShareImageName,
    );
  }
}
