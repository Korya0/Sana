import 'package:flutter/material.dart';
import 'package:sana/features/home/presentation/widgets/sections/azkar_category_bloc_builder.dart';
import 'package:sana/features/home/presentation/widgets/sections/prayer_category_section_bloc_builder.dart';
import 'package:sana/features/prayer/presentation/widgets/prayer_bloc_builder_widget.dart';
import 'package:sana/features/quran/presentation/widgets/quran_card/quran_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          // Prayer Section
          SliverToBoxAdapter(child: PrayerBlocBuilderWidget()),

          // Quran Card
          SliverPadding(
            padding: EdgeInsets.only(left: 8, right: 8, top: 16),
            sliver: SliverToBoxAdapter(child: QuranCard()),
          ),

          // Azkar Categoray
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 16),
            sliver: SliverToBoxAdapter(child: AzkarCategoryBlocBuilder()),
          ),

          // Features Categoray
          SliverPadding(
            padding: EdgeInsets.only(bottom: 24),
            sliver: SliverToBoxAdapter(child: FeaturesCategoryBlocBuilder()),
          ),
        ],
      ),
    );
  }
}
