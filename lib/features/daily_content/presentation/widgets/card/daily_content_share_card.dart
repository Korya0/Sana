import 'package:flutter/material.dart';
import 'package:sana/core/common/widgets/app_info_share.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/quran/presentation/widgets/quran_card/quran_card_background.dart';

class DailyContentShareCard extends StatelessWidget {
  final String? title;
  final String subTitle;
  final String? source;

  const DailyContentShareCard({
    super.key,
    this.title,
    required this.subTitle,
    this.source,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      decoration: QuranCardBackground.decoration,
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          const QuranCardBackground(),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null && title!.isNotEmpty) ...[
                  Text(
                    title!,
                    style: AppTextStyles.font22W700Gold(context),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 16),
                ],
                const SizedBox(height: 16),
                const SizedBox(height: 24),
                Column(
                  children: [
                    Text(
                      subTitle,
                      style: AppTextStyles.font26W700GoldQuran(
                        context,
                      ).copyWith(color: AppColors.white),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                    if (source != null && source!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        source!,
                        style: AppTextStyles.font14W400Gold(context),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 32),
                const AppInfoShare(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
