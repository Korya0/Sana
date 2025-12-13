import 'package:flutter/material.dart';
import 'package:sana/core/common/widgets/app_info_share.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/utils/widget_to_image.dart';
import 'package:sana/features/quran/presentation/widgets/quran_card/quran_card_background.dart';
import 'package:solar_icons/solar_icons.dart';

class DailyContentDialog extends StatefulWidget {
  final String title;
  final Widget content;

  const DailyContentDialog({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  State<DailyContentDialog> createState() => _DailyContentDialogState();
}

class _DailyContentDialogState extends State<DailyContentDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Content Card
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            decoration: QuranCardBackground.decoration,
            clipBehavior: Clip.hardEdge,
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  const QuranCardBackground(),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header
                        Text(
                          widget.title,
                          style: AppTextStyles.font22W700Gold(context),
                        ),
                        SizedBox(height: 24),

                        // Body
                        widget.content,

                        SizedBox(height: 32),

                        // Share Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _shareContent(context);
                            },
                            icon: Icon(
                              SolarIconsOutline.share,
                              color: Colors.black,
                            ),
                            label: Text(
                              "مشاركة",
                              style: AppTextStyles.font16W600White(
                                context,
                              ).copyWith(color: Colors.black),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.gold,
                              foregroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
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

  Future<void> _shareContent(BuildContext context) async {
    // 1. Create the widget to be captured
    final shareWidget = Container(
      width: 400, // Fixed width for consistent image
      decoration:
          QuranCardBackground.decoration, // Ensure decoration is applied
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          const QuranCardBackground(),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: AppTextStyles.font22W700Gold(context),
                ),
                SizedBox(height: 24),
                widget.content,
                SizedBox(height: 32),
                AppInfoShare(), // Footer
              ],
            ),
          ),
        ],
      ),
    );

    // 2. Use WidgetToImage util
    await WidgetToImage.shareWidget(
      context: context,
      widget: shareWidget,
      imageName: 'daily_content_share',
    );
  }
}
