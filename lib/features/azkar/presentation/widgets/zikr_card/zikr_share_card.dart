import 'package:flutter/material.dart';
import 'package:sana/core/common/widgets/app_info_share.dart';
import 'package:sana/core/common/widgets/custom_app_divider.dart';
import 'package:sana/core/common/widgets/share_card_container.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_card/zikr_content.dart';
import 'package:sana/features/quran/presentation/widgets/quran_card/quran_card_background.dart';

class ZikrShareCard extends StatelessWidget {
  const ZikrShareCard({required this.text, super.key, this.subText});
  final String text;
  final String? subText;

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
                  ZikrContent(text: text, subText: subText, isSharing: true),
                  const SizedBox(height: 32),
                  const CustomAppDivider(),
                  const SizedBox(height: 32),
                  const AppInfoShare(department: 'من الأذكار النبوية'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
