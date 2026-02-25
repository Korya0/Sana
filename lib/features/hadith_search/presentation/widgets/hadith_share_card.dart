import 'package:flutter/material.dart';
import 'package:sana/core/sharing/presentation/app_info_share.dart';
import 'package:sana/core/common/widgets/custom_app_divider.dart';
import 'package:sana/core/sharing/presentation/share_card_container.dart';
import 'package:sana/features/hadith_search/presentation/widgets/hadith_content_widget.dart';
import 'package:sana/features/quran/presentation/widgets/quran_card/quran_card_background.dart';

class HadithShareCard extends StatelessWidget {
  const HadithShareCard({required this.content, super.key});
  final String content;

  @override
  Widget build(BuildContext context) {
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
                      htmlContent: content,
                      isCentered: true,
                      isSharing:
                          true, // تفعيل منطق الـ 10 أسطر (8 متن + 2 بيانات)
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
