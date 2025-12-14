import 'package:flutter/material.dart';

import 'package:sana/core/common/widgets/share_buttons.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/utils/widget_to_image.dart';
import 'package:sana/features/quran/presentation/widgets/quran_card/quran_card_background.dart';
import 'package:sana/features/daily_content/presentation/widgets/card/daily_content_share_card.dart';

class DailyContentDialog extends StatelessWidget {
  final String title;
  final String mainContent;
  final String subContent;
  const DailyContentDialog({
    super.key,
    required this.title,
    required this.mainContent,
    required this.subContent,
  });

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
                  Positioned(
                    left: 0,
                    top: 16,
                    child: ShareButton(
                      iconSize: 26,
                      onSharePressed: () => _shareContent(context),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: AppTextStyles.font22W700Gold(context),
                        ),
                        SizedBox(height: 16),

                        // Body
                        Column(
                          children: [
                            Text(
                              mainContent,
                              style: AppTextStyles.font26W700GoldQuran(
                                context,
                              ).copyWith(color: AppColors.white),
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                            ),
                            SizedBox(height: 12),
                            Text(
                              subContent,
                              style: AppTextStyles.font14W400Gold(context),
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

  Future<void> _shareContent(BuildContext context) async {
    // 1. Create the widget to be captured
    final shareWidget = DailyContentShareCard(
      title: title,
      mainContent: mainContent,
      subContent: subContent,
    );

    // 2. Use WidgetToImage util
    await WidgetToImage.shareWidget(
      context: context,
      widget: shareWidget,
      imageName: 'daily_content_share',
    );
  }
}
