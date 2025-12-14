import 'package:flutter/material.dart';
import 'package:sana/features/home/presentation/widgets/sections/azkar_category_bloc_builder.dart';
import 'package:sana/features/home/presentation/widgets/sections/prayer_category_section_bloc_builder.dart';
import 'package:sana/features/quran/presentation/widgets/quran_card/quran_card.dart';

import 'package:sana/features/prayer/presentation/widgets/prayer_bloc_builder_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Prayer Section
          const SliverToBoxAdapter(child: PrayerBlocBuilderWidget()),

          // Quran Card
          SliverPadding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 16),
            sliver: SliverToBoxAdapter(child: QuranCard()),
          ),

          // Azkar Categoray
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            sliver: const SliverToBoxAdapter(child: AzkarCategoryBlocBuilder()),
          ),

          // Features Categoray
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 24),
            sliver: const SliverToBoxAdapter(
              child: FeaturesCategoryBlocBuilder(),
            ),
          ),
        ],
      ),
    );
  }
}
