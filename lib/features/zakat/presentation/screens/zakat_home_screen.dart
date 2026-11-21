import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/router/app_routes.dart';
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
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const HomeHeader(),
                          const SizedBox(height: 24),
                          FilledButton.icon(
                            onPressed: () =>
                                context.push(AppRoutes.zakatCalculateView),
                            icon: const Icon(Icons.calculate_outlined),
                            label: const Text(AppStrings.zakatStartCalculation),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: () =>
                                context.push(AppRoutes.zakatExplainView),
                            icon: const Icon(Icons.menu_book_outlined),
                            label: const Text(AppStrings.zakatReadExplanation),
                          ),
                          const SizedBox(height: 24),
                          const WhatIsZakatCard(),
                          const SizedBox(height: 16),
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
