import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/features/zakat/data/models/zakat_result.dart';
import 'package:sana/features/zakat/data/services/zakat_calculator.dart';
import 'package:sana/features/zakat/data/utils/number_utils.dart';
import '../zakat_info_card.dart';

class ResultExplanationCard extends StatelessWidget {
  const ResultExplanationCard({super.key, required this.result});

  final ZakatResult result;

  @override
  Widget build(BuildContext context) {
    return ZakatInfoCard(
      child: Text(
        _explanation(result),
        style: AppTextStyles.font16W400Loose(context),
      ),
    );
  }

  static String _explanation(ZakatResult r) {
    final currency = r.currency;
    final net = NumberUtils.formatMoney(r.netAmount, currency: currency);
    switch (r.status) {
      case ZakatStatus.due:
        return AppStrings.zakatStatusDueExplanation(
          net,
          NumberUtils.formatMoney(r.nisabValue!, currency: currency),
          NumberUtils.formatMoney(r.zakatAmount, currency: currency),
        );
      case ZakatStatus.belowNisab:
        return AppStrings.zakatStatusBelowExplanation(
          net,
          NumberUtils.formatMoney(r.nisabValue!, currency: currency),
        );
      case ZakatStatus.hawlNotCompleted:
        return AppStrings.zakatStatusHawlExplanation(
          net,
          NumberUtils.formatMoney(r.nisabValue!, currency: currency),
        );
      case ZakatStatus.nisabUnknown:
        return AppStrings.zakatStatusUnknownExplanation(
          net,
          ZakatCalculator.rate,
        );
    }
  }
}
