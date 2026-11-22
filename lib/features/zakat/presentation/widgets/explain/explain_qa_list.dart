import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'qa_card.dart';

class ExplainQaList extends StatelessWidget {
  const ExplainQaList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const QaCard(
          question: AppStrings.zakatQaWhat,
          answer: AppStrings.zakatQaWhatAnswer,
        ),
        AppGap.h(AppSize.p12),
        const QaCard(
          question: AppStrings.zakatQaWhen,
          answer: AppStrings.zakatQaWhenAnswer,
        ),
        AppGap.h(AppSize.p12),
        const QaCard(
          question: AppStrings.zakatQaNisab,
          answer: AppStrings.zakatQaNisabAnswer,
        ),
        AppGap.h(AppSize.p12),
        const QaCard(
          question: AppStrings.zakatQaHawl,
          answer: AppStrings.zakatQaHawlAnswer,
        ),
        AppGap.h(AppSize.p12),
        const QaCard(
          question: AppStrings.zakatQaRate,
          answer: AppStrings.zakatQaRateAnswer,
        ),
      ],
    );
  }
}
