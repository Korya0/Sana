import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/services/sharing/presentation/utils/app_share.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/daily_content/presentation/widgets/share_card/daily_content_share_card.dart';
import 'package:sana/features/prayer/domain/entities/religious_event_entity.dart';
import 'package:solar_icons/solar_icons.dart';

class ReligiousEventCarouselCard extends StatelessWidget {
  const ReligiousEventCarouselCard({
    required this.event,
    this.isToday = true,
    super.key,
  });

  final ReligiousEventEntity event;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showEventDialog(context),
      child: Center(
        child: Column(
          spacing: AppSpacing.v2,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isToday ? AppStrings.eventToday : AppStrings.upcomingEvent,
              style: AppTextStyles.font12W500(context).copyWith(
                color: context.color.textSecondary,
              ),
            ),
            Text(
              event.displayName,
              style: AppTextStyles.font14W700(context).copyWith(
                color: context.color.primary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              AppStrings.tapToKnowVirtue,
              style: AppTextStyles.font12W500(context).copyWith(
                color: context.color.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
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
      backgroundIcon: SolarIconsBold.starFall,
      onSharePressed: () async => AppShare.shareWidgetAsImage(
        context: context,
        widget: DailyContentShareCard(
          title: event.displayName,
          subTitle: event.hadithText ?? AppStrings.noVirtueAvailable,
          source: event.bookInfo,
          department: AppStrings.religiousEventsDepartment,
        ),
        imageName: AppStrings.prayerStatusShareImageName,
      ),
      onCopyPressed: () async {
        final text =
            '${event.displayName}\n${event.hadithText ?? ""}\n${event.bookInfo ?? ""}';
        await Clipboard.setData(ClipboardData(text: text.trim()));
      },
    );
  }
}
