import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_strings.dart';
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
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                VerdictCard(result: result),
                const SizedBox(height: 16),
                const ZakatSectionTitle('تفاصيل الحساب'),
                AssetsBreakdownCard(result: result),
                const SizedBox(height: 16),
                const ZakatSectionTitle('كيف وصلنا إلى النتيجة؟'),
                ResultExplanationCard(result: result),
                const SizedBox(height: 12),
                const ZakatNoteBox(
                  AppStrings.zakatResultDisclaimer,
                  icon: Icons.warning_amber_rounded,
                ),
                const SizedBox(height: 20),
                const ResultActionButtons(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
