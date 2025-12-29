import 'package:flutter/material.dart';
import 'package:sana/core/common/widgets/app_info_share.dart';
import 'package:sana/core/common/widgets/share_card_container.dart';
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
    final String department = title?.contains('حديث') == true
        ? 'من الحديث اليومي'
        : 'من سنة الحبيب ﷺ';

    return ShareCardContainer(
      child: Container(
        width: double.infinity,
        decoration: QuranCardBackground.decoration.copyWith(
          borderRadius: BorderRadius.zero,
          boxShadow: [],
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const QuranCardBackground(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (title != null && title!.isNotEmpty) ...[
                    Text(
                      title!,
                      style: AppTextStyles.font22W700Gold(context),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                  ],
                  Text(
                    subTitle,
                    style: AppTextStyles.font26W700GoldQuran(
                      context,
                    ).copyWith(color: AppColors.white),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (source != null && source!.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(
                      source!,
                      style: AppTextStyles.font14W400Gold(context),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                  const SizedBox(height: 48),
                  AppInfoShare(department: department),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
