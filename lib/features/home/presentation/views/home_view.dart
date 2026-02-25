import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/features/asma_ul_husna/presentation/widgets/asma_ul_husna_name_of_the_day_card.dart';
import 'package:sana/features/azkar/presentation/controller/azkar_categories_cubit.dart';
import 'package:sana/features/home/presentation/controller/features_list_cubit.dart';
import 'package:sana/features/home/presentation/widgets/sections/azkar_category_bloc_builder.dart';
import 'package:sana/features/home/presentation/widgets/sections/home_settings_section.dart';
import 'package:sana/features/home/presentation/widgets/sections/prayer_category_section_bloc_builder.dart';
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
          return Scaffold(
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                const SliverToBoxAdapter(child: PrayerBlocBuilderWidget()),
                SliverToBoxAdapter(
                  child: CarouselSlider(
                    items: const [
                      QuranCard(),
                      AsmaUlHusnaNameOfTheDayCard(),
                    ],
                    options: CarouselOptions(
                      height: 140,
                      viewportFraction: 0.96,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SizedBox(height: 18),
                      AzkarCategoryBlocBuilder(),
                      SizedBox(height: 16),
                      FeaturesCategoryBlocBuilder(),
                      SizedBox(height: 18),
                      HomeSettingsSection(),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
