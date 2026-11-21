import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/router/app_routes.dart';
import '../widgets/common_zakat_widgets.dart';
import '../widgets/explain/categories_card.dart';
import '../widgets/explain/example_card.dart';
import '../widgets/explain/explain_qa_list.dart';

class ZakatExplainScreen extends StatelessWidget {
  const ZakatExplainScreen({super.key});

  static const _categories = [
    'الفقراء',
    'المساكين',
    'العاملون عليها',
    'المؤلفة قلوبهم',
    'في الرقاب (تحرير الرقاب)',
    'الغارمون (المدينون)',
    'في سبيل الله',
    'ابن السبيل',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.zakatExplain)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const ExplainQaList(),
                const SizedBox(height: 12),
                const CategoriesCard(categories: _categories),
                const SizedBox(height: 12),
                const ExampleCard(),
                const SizedBox(height: 12),
                const ZakatNoteBox(AppStrings.zakatDisclaimerControversial),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () => context.push(AppRoutes.zakatCalculateView),
                  icon: const Icon(Icons.calculate_outlined),
                  label: const Text(AppStrings.zakatStartCalculation),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
