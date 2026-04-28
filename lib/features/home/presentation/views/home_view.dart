import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/services/location_manager/presentation/cubit/location_name/location_name_cubit.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar_categories_cubit.dart';
import 'package:sana/features/daily_content/presentation/cubit/daily_content_cubit.dart';
import 'package:sana/features/asma_ul_husna/presentation/cubit/asma_ul_husna_cubit.dart';
import 'package:sana/features/home/presentation/cubit/features_list_cubit.dart';
import 'package:sana/features/home/presentation/widgets/sections/home_azkar_category_section.dart';
import 'package:sana/features/home/presentation/widgets/sections/home_daily_wisdom_section.dart';
import 'package:sana/features/home/presentation/widgets/sections/home_features_category_section.dart';
import 'package:sana/features/home/presentation/widgets/sections/home_prayer_section.dart';
import 'package:sana/features/home/presentation/widgets/sections/home_settings_section.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<LocationNameCubit>()),
        BlocProvider.value(value: sl<DailyContentCubit>()),
        BlocProvider(
          create: (context) {
            final cubit = sl<AzkarCategoriesCubit>();
            unawaited(cubit.loadAzkar());
            return cubit;
          },
        ),
        BlocProvider(
          create: (context) {
            final cubit = sl<FeaturesListCubit>()..getFeatures();
            return cubit;
          },
        ),
        BlocProvider(
          create: (context) {
            final cubit = sl<AsmaUlHusnaCubit>();
            unawaited(cubit.loadDailyName());
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
                SliverToBoxAdapter(child: HomePrayerSection()),
                SliverPadding(
                  padding: EdgeInsets.only(top: AppSpacing.v18),
                  sliver: SliverToBoxAdapter(
                    child: HomeFeaturesCategorySection(),
                  ),
                ),
                SliverToBoxAdapter(child: HomeDailyWisdomSection()),
                SliverPadding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.v18),
                  sliver: SliverToBoxAdapter(child: HomeAzkarCategorySection()),
                ),

                SliverPadding(
                  padding: EdgeInsets.only(bottom: AppSpacing.v24),
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
