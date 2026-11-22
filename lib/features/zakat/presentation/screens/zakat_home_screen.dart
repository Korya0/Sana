import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/router/app_routes.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_button.dart';
import '../widgets/common_zakat_widgets.dart';
import '../widgets/home/home_header.dart';
import '../widgets/home/what_is_zakat_card.dart';

class ZakatHomeScreen extends StatelessWidget {
  const ZakatHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.zakatTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: AppSize.contentMaxWidth,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(AppSize.p20),
                      child: Column(
                        children: [
                          const HomeHeader(),
                          AppGap.h(AppSize.p24),
                          AppButton(
                            label: AppStrings.zakatStartCalculation,
                            icon: AppIcons.calculate,
                            expand: true,
                            onPressed: () =>
                                context.push(AppRoutes.zakatCalculateView),
                          ),
                          AppGap.h(AppSize.p12),
                          AppButton(
                            label: AppStrings.zakatReadExplanation,
                            icon: AppIcons.book,
                            expand: true,
                            variant: AppButtonVariant.secondary,
                            onPressed: () =>
                                context.push(AppRoutes.zakatExplainView),
                          ),
                          AppGap.h(AppSize.p24),
                          const WhatIsZakatCard(),
                          AppGap.h(AppSize.p16),
                          const ZakatNoteBox(AppStrings.zakatDisclaimer),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
