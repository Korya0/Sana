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
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_section/azkar_section_widget.dart';
import 'package:sana/features/azkar/presentation/widgets/reading_settings/reading_settings_bottom_sheet.dart';

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
      BlocProvider<ReadingSettingsCubit>(
        create: (context) {
          final cubit = sl<ReadingSettingsCubit>();
          unawaited(cubit.loadSettings());
          return cubit;
        },
      ),
    ],
    child: Builder(
      builder: (context) => Scaffold(
        body: CustomScrollView(
          slivers: [
            // App bar
            CommonSliverAppBar(
              title: AppStrings.azkarTasbeehHeader,
              hasBackButton: false,
              actions: [
                // Reminders
                AppIconButton(
                  icon: AppIcons.notification,
                  tooltip: AppStrings.remindersTitle,
                  onPressed: () =>
                      context.pushNamed(AppRoutes.azkarRemindersPath),
                ),

                // Reading settings
                AppIconButton(
                  icon: AppIcons.moreVertical,
                  tooltip: AppStrings.readingSettingsTitle,
                  onPressed: () => unawaited(
                    AppBottomSheet.show<void>(
                      context: context,
                      child: ReadingSettingsBottomSheet(
                        cubit: context.read<ReadingSettingsCubit>(),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Azkar categories section
            const SliverPadding(
              padding: EdgeInsets.only(top: 0),
              sliver: AzkarSectionWidget(),
            ),

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

