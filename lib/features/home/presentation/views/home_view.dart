import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/services/app_date/presentation/cubit/app_date_cubit.dart';
import 'package:sana/core/services/location_manager/presentation/cubit/location_name/location_name_cubit.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/features/asma_ul_husna/presentation/cubit/asma_ul_husna_cubit.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar_categories_cubit.dart';
import 'package:sana/features/daily_content/presentation/cubit/daily_content_cubit.dart';
import 'package:sana/features/home/presentation/cubit/features_list_cubit.dart';
import 'package:sana/features/home/presentation/widgets/sections/home_azkar_category_section.dart';
import 'package:sana/features/home/presentation/widgets/sections/home_daily_wisdom_section.dart';
import 'package:sana/features/home/presentation/widgets/sections/home_features_category_section.dart';
import 'package:sana/features/home/presentation/widgets/sections/home_prayer_section.dart';
import 'package:sana/features/home/presentation/widgets/sections/home_settings_section.dart';
import 'package:sana/features/prayer/presentation/cubit/prayer_times_cubit.dart';

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
            // Start immediately
            unawaited(cubit.loadAzkar());
            return cubit;
          },
        ),
        BlocProvider(
          create: (context) {
            final cubit = sl<FeaturesListCubit>();
            // Delay by 100ms
            unawaited(
              Future<void>.delayed(
                const Duration(milliseconds: 100),
              ).then((_) => cubit.getFeatures()),
            );
            return cubit;
          },
        ),
        BlocProvider(
          create: (context) {
            final cubit = sl<AsmaUlHusnaCubit>();
            // Delay by 200ms
            unawaited(
              Future<void>.delayed(
                const Duration(milliseconds: 200),
              ).then((_) => cubit.loadDailyName()),
            );
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
                SliverToBoxAdapter(
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: sl<AppDateCubit>()),
                      BlocProvider.value(value: sl<PrayerTimesCubit>()),
                    ],
                    child: const HomePrayerSection(),
                  ),
                ),
                const SliverPadding(
                  padding: EdgeInsets.only(top: AppSpacing.v10),
                  sliver: SliverToBoxAdapter(
                    child: HomeFeaturesCategorySection(),
                  ),
                ),
                const SliverToBoxAdapter(child: HomeDailyWisdomSection()),
                const SliverPadding(
                  // padding 16 for See moree buton to easy tap it
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.v16),
                  sliver: SliverToBoxAdapter(child: HomeAzkarCategorySection()),
                ),

                const SliverPadding(
                  padding: EdgeInsets.only(bottom: AppSpacing.v10),
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
