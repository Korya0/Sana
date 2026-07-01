import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/services/sharing/presentation/utils/widget_to_image_helper.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/daily_content/presentation/widgets/share_card/daily_content_share_card.dart';
import 'package:sana/features/prayer/domain/entities/prayer_time_status.dart';
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppStrings.tapToKnowVirtue,
              style: AppTextStyles.font12W500(context).copyWith(
                color: context.color.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              status.status,
              style: AppTextStyles.font14W700(context).copyWith(
                color: context.color.primary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
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
      backgroundIcon: SolarIconsBold.starFall,
      onSharePressed: () async => WidgetToImageHelper.shareWidget(
        context: context,
        widget: DailyContentShareCard(
          title: status.status,
          subTitle: status.description,
          source: status.source,
          department: AppStrings.prayerVirtuesDepartment,
        ),
        imageName: AppStrings.prayerStatusShareImageName,
      ),
      onCopyPressed: () async {
        final text =
            '${status.status}\n${status.description}\n${status.source}';
        await Clipboard.setData(ClipboardData(text: text.trim()));
      },
    );
  }
}
