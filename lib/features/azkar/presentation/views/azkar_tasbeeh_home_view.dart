import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/router/app_routes.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_icon_button.dart';
import 'package:sana/core/widgets/overlays/app_bottom_sheet.dart';
import 'package:sana/core/widgets/slivers/common_sliver_app_bar.dart';
import 'package:sana/features/azkar/presentation/cubits/categories/azkar_categories_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/custom_azkar/custom_azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_tasbeeh_home/azkar/azkar_home_options_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_tasbeeh_home/azkar/azkar_section_widget.dart';
import 'package:sana/features/azkar/presentation/widgets/common/azkar_tasbeeh_settings_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_tasbeeh_home/tasbeeh/tasbeeh_home_card.dart';

class AzkarTasbeehHomeView extends StatelessWidget {
  // Creates view
  const AzkarTasbeehHomeView({super.key});

  // Opens options
  Future<void> _openOptions(BuildContext context) async {
    final option = await AppBottomSheet.show<AzkarHomeOption>(
      context: context,
      child: AzkarHomeOptionsBottomSheet(
        azkarTasbeehSettingsCubit: context.read<AzkarTasbeehSettingsCubit>(),
      ),
    );

    if (!context.mounted || option == null) return;

    switch (option) {
      case AzkarHomeOption.fontSize:
        await _openAzkarTasbeehSettings(context);
      case AzkarHomeOption.createCustomAzkar:
        await context.pushNamed(AppRoutes.customAzkarFormView);
        if (context.mounted) {
          unawaited(context.read<AzkarCategoriesCubit>().loadCategories());
        }
      case AzkarHomeOption.manageCustomAzkar:
        await context.pushNamed(AppRoutes.customAzkarView);
        if (context.mounted) {
          unawaited(context.read<AzkarCategoriesCubit>().loadCategories());
        }
    }
  }

  // Opens settings
  Future<void> _openAzkarTasbeehSettings(BuildContext context) async {
    final goBack = await AppBottomSheet.show<bool>(
      context: context,
      child: AzkarTasbeehSettingsBottomSheet(
        cubit: context.read<AzkarTasbeehSettingsCubit>(),
        showBackButton: true,
      ),
    );

    if (goBack != true || !context.mounted) return;
    await _openOptions(context);
  }

  // Builds view
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
            // Header
            CommonSliverAppBar(
              title: AppStrings.azkarTasbeehHeader,
              hasBackButton: false,
              centerTitle: false,
              actions: [
                // Options action
                AppIconButton(
                  icon: AppIcons.tuning,
                  tooltip: AppStrings.azkarHomeOptions,
                  onPressed: () => unawaited(_openOptions(context)),
                ),
              ],
            ),

            // Tasbeeh
            const TasbeehHomeCard(),

            // Body
            const AzkarSectionWidget(),

            // Bottom gap
            SliverToBoxAdapter(
              child: AppGap.h(AppSize.sbp),
            ),
          ],
        ),
      ),
    ),
  );
}
