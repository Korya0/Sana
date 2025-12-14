import 'package:flutter/material.dart';
import 'package:sana/core/common/widgets/app_info_share.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/quran/presentation/widgets/quran_card/quran_card_background.dart';

class DailyContentShareCard extends StatelessWidget {
  final String title;
  final String mainContent;
  final String subContent;

  const DailyContentShareCard({
    super.key,
    required this.title,
    required this.mainContent,
    required this.subContent,
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
                Text(
                  title,
                  style: AppTextStyles.font22W700Gold(context),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 24),
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
                    const SizedBox(height: 12),
                    Text(
                      subContent,
                      style: AppTextStyles.font14W400Gold(context),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
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
