import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/common/widgets/app_toast.dart';
import 'package:sana/core/sharing/logic/widget_to_image.dart';
import 'package:sana/core/sharing/presentation/combined_share_copy_button.dart';
import 'package:sana/core/utils/cusotm_app_card_decoration.dart';
import 'package:sana/features/daily_content/presentation/widgets/card/daily_content_share_card.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:solar_icons/solar_icons.dart';

class PrayerStatusDetailsDialog extends StatelessWidget {
  const PrayerStatusDetailsDialog({
    required this.title,
    required this.content,
    this.source,
    this.categoryLabel = 'فضل الوقت',
    super.key,
  });

  final String title;
  final String content;
  final String? source;
  final String categoryLabel;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        decoration: customAppCardDecoration(),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Positioned(
              right: -10,
              bottom: -20,
              child: Icon(
                SolarIconsBold.book,
                size: 150,
                color: AppColors.white.withValues(alpha: 0.05),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const IconButton(
                        onPressed: null,
                        icon: SizedBox(width: 24),
                      ),
                      Text(
                        categoryLabel,
                        style: AppTextStyles.font14W400Gold(context),
                      ),
                      CombinedShareCopyButton(
                        onCopyPressed: () => _copyContent(context),
                        onSharePressed: () => _shareContent(context),
                        iconSize: 24,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: AppTextStyles.font22W700Gold(context),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            content,
                            style: AppTextStyles.font26W700GoldQuran(context)
                                .copyWith(
                                  color: AppColors.white,
                                  fontSize: 22,
                                ),
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                          ),
                          if (source != null) ...[
                            const SizedBox(height: 16),
                            Text(
                              source!,
                              style: AppTextStyles.font14W400Gold(context)
                                  .copyWith(
                                    color: AppColors.white.withAlpha(150),
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _copyContent(BuildContext context) {
    final text = '$title\n$content${source != null ? "\n$source" : ""}';
    unawaited(
      Clipboard.setData(ClipboardData(text: text)).then((_) {
        if (context.mounted) {
          AppToast.show(context, 'تم نسخ المحتوى بنجاح');
        }
      }),
    );
  }

  void _shareContent(BuildContext context) {
    unawaited(
      WidgetToImage.shareWidget(
        context: context,
        widget: DailyContentShareCard(
          title: title,
          subTitle: content,
          source: source,
        ),
        imageName: 'prayer_status_share',
      ),
    );
  }
}
