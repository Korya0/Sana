// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sana/core/common/widgets/app_info_share.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/common/widgets/islamic_divider.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_card/zikr_content.dart';

class ZikrShareCard extends StatelessWidget {
  final String text;
  final String? subText;

  const ZikrShareCard({super.key, required this.text, this.subText});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - (32),
      padding: EdgeInsets.all((20)),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        border: Border.all(color: AppColors.gold.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Zikr Content
          ZikrContent(text: text, subText: subText),

          SizedBox(height: (24)),

          // Divider
          const CustomAppDivider(),

          SizedBox(height: (12)),

          // Footer: App Info & QR Code
          AppInfoShare(),
        ],
      ),
    );
  }
}
