import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/categories/azkar_categories_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/custom_azkar/custom_azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/utils/azkar_home_options_flow.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_tasbeeh_home/azkar/azkar_section_widget.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_tasbeeh_home/tasbeeh/tasbeeh_home_card.dart';

class AzkarTasbeehHomeView extends StatelessWidget {
  const AzkarTasbeehHomeView({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider<AzkarCategoriesCubit>(
        create: (context) {
          final cubit = sl<AzkarCategoriesCubit>();
          unawaited(cubit.loadCategories());
          return cubit;
        },
      ),
      BlocProvider<CustomAzkarCubit>(
        create: (context) {
          final cubit = sl<CustomAzkarCubit>();
          unawaited(cubit.loadCustomCategories());
          return cubit;
        },
      ),
      BlocProvider<AzkarTasbeehSettingsCubit>(
        create: (context) {
          final cubit = sl<AzkarTasbeehSettingsCubit>();
          unawaited(cubit.loadSettings());
          return cubit;
        },
      ),
    ],
    child: Builder(
      builder: (context) => Scaffold(
        body: CustomScrollView(
          slivers: [
            // Tasbeeh
            SliverSafeArea(
              bottom: false,
              sliver: SliverPadding(
                padding: AppSize.shp.copyWith(top: AppSize.stp),
                sliver: const SliverToBoxAdapter(child: TasbeehHomeCard()),
              ),
            ),
            // Azkar
            AzkarSectionWidget(
              onOptionsPressed: () =>
                  unawaited(AzkarHomeOptionsFlow.open(context)),
            ),
            // Bottom gap
            SliverToBoxAdapter(child: AppGap.h(AppSize.sbp)),
          ],
        ),
      ),
    ),
  );
}
