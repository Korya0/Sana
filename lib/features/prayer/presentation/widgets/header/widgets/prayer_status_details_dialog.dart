import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/common/widgets/app_toast.dart';
import 'package:sana/core/sharing/logic/widget_to_image.dart';
import 'package:sana/core/sharing/presentation/combined_share_copy_button.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/utils/cusotm_app_card_decoration.dart';
import 'package:sana/features/daily_content/presentation/widgets/card/daily_content_share_card.dart';
import 'package:sana/features/prayer/data/models/prayer_time_status.dart';
import 'package:solar_icons/solar_icons.dart';

class PrayerStatusDetailsDialog extends StatelessWidget {
  const PrayerStatusDetailsDialog({
    required this.status,
    this.label,
    super.key,
  });

  final PrayerTimeStatus status;
  final String? label;

  static void show(
    BuildContext context,
    PrayerTimeStatus status, {
    String? label,
  }) {
    unawaited(
      showDialog(
        context: context,
        builder: (context) =>
            PrayerStatusDetailsDialog(status: status, label: label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine dynamic values based on label
    final isEvent = label == 'مناسبة دينية' || label == 'حديث نبوي';
    final shareDepartment = isEvent
        ? 'من المناسبات الإسلامية'
        : 'من فضل الأوقات';

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.75,
            ),
            decoration: customAppCardDecoration(),
            clipBehavior: Clip.hardEdge,
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  // Icon Background
                  Positioned(
                    right: -10,
                    bottom: -20,
                    child: Icon(
                      SolarIconsBold.starFall,
                      size: 150,
                      color: AppColors.white.withValues(alpha: 0.05),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title
                        Text(
                          status.status,
                          style: AppTextStyles.font22W700Gold(context),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // Body (The Content)
                        Text(
                          status.description,
                          style: AppTextStyles.font20W700White(context)
                              .copyWith(
                                color: AppColors.white,
                                height: 1.6,
                              ),
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                        ),

                        const SizedBox(height: 24),

                        // Source (Always visible, now below content)
                        if (status.source != null && status.source!.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.gold.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              status.source!,
                              style: AppTextStyles.font14W400Gold(context)
                                  .copyWith(
                                    color: AppColors.gold.withValues(
                                      alpha: 0.8,
                                    ),
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                        const SizedBox(height: 48),

                        // Footer Row: Close (Center) and Share (End)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 1. Spacer to balance the Share button on the other side
                            const Expanded(child: SizedBox()),

                            // 2. Close Button (Center)
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                backgroundColor: AppColors.gold.withValues(
                                  alpha: 0.1,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    SolarIconsOutline.closeCircle,
                                    color: AppColors.gold,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'إغلاق',
                                    style: AppTextStyles.font14W600Gold(
                                      context,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // 2. Share/Copy Button (Bottom Left)
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: CombinedShareCopyButton(
                                  onSharePressed: () async =>
                                      WidgetToImage.shareWidget(
                                        context: context,
                                        widget: DailyContentShareCard(
                                          title: status.status,
                                          subTitle: status.description,
                                          source: status.source,
                                          department: shareDepartment,
                                        ),
                                        imageName: 'prayer_status_share',
                                      ),
                                  onCopyPressed: () async {
                                    final text =
                                        '${status.status}\n${status.description}${status.source != null ? "\n${status.source}" : ""}';
                                    await Clipboard.setData(
                                      ClipboardData(text: text),
                                    ).then((_) {
                                      if (context.mounted) {
                                        AppToast.show(
                                          context,
                                          'تم النسخ بنجاح',
                                        );
                                      }
                                    });
                                  },
                                  iconSize: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
