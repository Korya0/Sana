import 'package:flutter/material.dart';
import 'package:sana/core/sharing/presentation/app_info_share.dart';
import 'package:sana/core/common/widgets/custom_app_divider.dart';
import 'package:sana/core/sharing/presentation/share_card_container.dart';
import 'package:sana/features/hadith_search/presentation/widgets/hadith_content_widget.dart';
import 'package:sana/features/quran/presentation/widgets/quran_card/quran_card_background.dart';

import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';

class HadithShareCard extends StatelessWidget {
  const HadithShareCard({
    required this.hadith,
    super.key,
  });
  final HadithEntity hadith;

  Color _getJudgmentColor(String? judgment) {
    if (judgment == null) return AppColors.gold;
    final j = judgment.toLowerCase();
    if (j.contains('صحيح') || j.contains('جيد') || j.contains('ثابت')) {
      return Colors.green.shade400;
    }
    if (j.contains('حسن')) {
      return AppColors.gold;
    }
    if (j.contains('ضعيف') ||
        j.contains('منكر') ||
        j.contains('لا يصح') ||
        j.contains('موضوع') ||
        j.contains('باطل') ||
        j.contains('كذب')) {
      return Colors.red.shade400;
    }
    return AppColors.gold;
  }

  @override
  Widget build(BuildContext context) {
    final judgmentColor = _getJudgmentColor(hadith.judgment);
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
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 500),
                    child: HadithContentWidget(
                      htmlContent: hadith.hadithContent,
                      isCentered: true,
                      isSharing: true,
                      judgmentColor: judgmentColor,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const CustomAppDivider(),
                  const SizedBox(height: 32),
                  const AppInfoShare(
                    department: 'من الموسوعة الحديثية - الدرر السنية',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
