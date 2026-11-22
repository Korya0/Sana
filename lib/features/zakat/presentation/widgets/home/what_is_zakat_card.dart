import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import '../zakat_info_card.dart';
import '../zakat_section_title.dart';

class WhatIsZakatCard extends StatelessWidget {
  const WhatIsZakatCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ZakatInfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ZakatSectionTitle(AppStrings.zakatWhatIs),
          Text(
            AppStrings.zakatWhatIsBody,
            style: AppTextStyles.font16W400Loose(context),
          ),
        ],
      ),
    );
  }
}
