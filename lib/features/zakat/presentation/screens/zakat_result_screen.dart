import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/features/zakat/data/models/zakat_result.dart';
import '../widgets/common_zakat_widgets.dart';
import '../widgets/result/assets_breakdown_card.dart';
import '../widgets/result/result_action_buttons.dart';
import '../widgets/result/result_explanation_card.dart';
import '../widgets/result/verdict_card.dart';

class ZakatResultScreen extends StatelessWidget {
  const ZakatResultScreen({super.key, required this.result});

  final ZakatResult result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.zakatResult)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSize.contentMaxWidth,
            ),
            child: ListView(
              padding: EdgeInsets.all(AppSize.p16),
              children: [
                VerdictCard(result: result),
                AppGap.h(AppSize.p16),
                const ZakatSectionTitle(AppStrings.zakatResultDetails),
                AssetsBreakdownCard(result: result),
                AppGap.h(AppSize.p16),
                const ZakatSectionTitle(AppStrings.zakatResultHow),
                ResultExplanationCard(result: result),
                AppGap.h(AppSize.p12),
                const ZakatNoteBox(
                  AppStrings.zakatResultDisclaimer,
                  icon: AppIcons.warning,
                ),
                AppGap.h(AppSize.p20),
                const ResultActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
