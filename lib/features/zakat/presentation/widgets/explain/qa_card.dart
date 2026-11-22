import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/widgets/app_gap.dart';
import '../zakat_info_card.dart';

class QaCard extends StatelessWidget {
  const QaCard({super.key, required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return ZakatInfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              question,
              style: AppTextStyles.font19W700Brand(context),
            ),
          ),
          AppGap.h(AppSize.p8),
          Text(answer, style: AppTextStyles.font16W400Loose(context)),
        ],
      ),
    );
  }
}
