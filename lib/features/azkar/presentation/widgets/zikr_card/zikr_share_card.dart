// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sana/core/common/widgets/app_info_share.dart';
import 'package:sana/core/common/widgets/islamic_divider.dart';
import 'package:sana/core/common/widgets/share_card_container.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_card/zikr_content.dart';

class ZikrShareCard extends StatelessWidget {
  final String text;
  final String? subText;

  const ZikrShareCard({super.key, required this.text, this.subText});

  @override
  Widget build(BuildContext context) {
    return ShareCardContainer(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        decoration: const BoxDecoration(color: AppColors.scaffoldBackground),
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
    );
  }
}
