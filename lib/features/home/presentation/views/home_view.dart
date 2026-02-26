import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/features/azkar/presentation/controller/azkar_categories_cubit.dart';
import 'package:sana/features/home/presentation/controller/features_list_cubit.dart';
import 'package:sana/features/home/presentation/widgets/sections/azkar_category_bloc_builder.dart';
import 'package:sana/features/home/presentation/widgets/sections/features_category_bloc_builder.dart';
import 'package:sana/features/home/presentation/widgets/sections/home_settings_section.dart';
import 'package:sana/features/home/presentation/widgets/sections/daily_wisdom_section.dart';
import 'package:sana/features/prayer/presentation/widgets/prayer_bloc_builder_widget.dart';
import 'package:sana/features/quran/presentation/widgets/quran_card/quran_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final cubit = sl<AzkarCategoriesCubit>();
            unawaited(cubit.loadAzkar());
            return cubit;
          },
        ),
        BlocProvider(
          create: (context) {
            final cubit = sl<FeaturesListCubit>()..loadFeatures();
            return cubit;
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          return const Scaffold(
            body: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: PrayerBlocBuilderWidget()),
                SliverToBoxAdapter(child: QuranCard()),
                SliverPadding(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  sliver: SliverToBoxAdapter(child: AzkarCategoryBlocBuilder()),
                ),
                SliverToBoxAdapter(child: DailyWisdomSection()),
                SliverPadding(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  sliver: SliverToBoxAdapter(
                    child: FeaturesCategoryBlocBuilder(),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(bottom: 24),
                  sliver: SliverToBoxAdapter(child: HomeSettingsSection()),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
