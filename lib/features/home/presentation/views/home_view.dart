import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/services/location_manager/presentation/cubit/location_name/location_name_cubit.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/features/daily_content/presentation/cubit/daily_content_cubit.dart';
import 'package:sana/features/home/presentation/cubit/features_list_cubit.dart';
import 'package:sana/features/home/presentation/widgets/sections/home_daily_wisdom_section.dart';
import 'package:sana/features/home/presentation/widgets/sections/home_features_category_section.dart';
import 'package:sana/features/home/presentation/widgets/sections/home_prayer_section.dart';
import 'package:sana/features/prayer/presentation/cubit/prayer_times_cubit.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final dailyCubit = sl<DailyContentCubit>();
    unawaited(dailyCubit.loadDailyContent());
    final featuresCubit = sl<FeaturesListCubit>();
    unawaited(featuresCubit.getFeatures());
    final prayerCubit = sl<PrayerTimesCubit>();

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<LocationNameCubit>()),
        BlocProvider.value(value: dailyCubit),
        BlocProvider.value(value: featuresCubit),
        BlocProvider.value(value: prayerCubit),
      ],
      child: const Scaffold(
        body: CustomScrollView(
          physics: ClampingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: HomePrayerSection(),
            ),
            SliverPadding(
              padding: EdgeInsets.only(
                top: AppSpacing.v12,
              ),
              sliver: HomeFeaturesCategorySection(),
            ),
            SliverPadding(
              padding: EdgeInsets.only(bottom: AppSpacing.v16),
              sliver: SliverToBoxAdapter(child: HomeDailyWisdomSection()),
            ),
          ],
        ),
      ),
    );
  }
}
