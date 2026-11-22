import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/router/app_routes.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_button.dart';
import '../widgets/common_zakat_widgets.dart';
import '../widgets/explain/categories_card.dart';
import '../widgets/explain/example_card.dart';
import '../widgets/explain/explain_qa_list.dart';

class ZakatExplainScreen extends StatelessWidget {
  const ZakatExplainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.zakatExplain)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSize.contentMaxWidth,
            ),
            child: ListView(
              padding: EdgeInsets.all(AppSize.p16),
              children: [
                const ExplainQaList(),
                AppGap.h(AppSize.p12),
                const CategoriesCard(categories: AppStrings.zakatRecipients),
                AppGap.h(AppSize.p12),
                const ExampleCard(),
                AppGap.h(AppSize.p12),
                const ZakatNoteBox(AppStrings.zakatDisclaimerControversial),
                AppGap.h(AppSize.p20),
                AppButton(
                  label: AppStrings.zakatStartCalculation,
                  icon: AppIcons.calculate,
                  expand: true,
                  onPressed: () => context.push(AppRoutes.zakatCalculateView),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
