import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/buttons/app_primary_button.dart';
import 'package:sana/core/widgets/slivers/common_sliver_app_bar.dart';
import 'package:sana/core/widgets/views/app_error_view.dart';
import 'package:sana/core/widgets/views/app_state_view.dart';
import 'package:sana/features/azkar/presentation/cubits/custom_azkar/custom_azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/custom_azkar/custom_azkar_state.dart';
import 'package:sana/features/azkar/presentation/utils/open_custom_azkar_form.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_list/custom_azkar_list_section.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_list/custom_azkar_list_skeleton.dart';

class CustomAzkarListView extends StatelessWidget {
  const CustomAzkarListView({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<CustomAzkarCubit>(
    create: (context) {
      final cubit = sl<CustomAzkarCubit>();
      unawaited(cubit.loadCustomCategories());
      return cubit;
    },
    child: Builder(
      builder: (context) => Scaffold(
        body: CustomScrollView(
          slivers: [
            const CommonSliverAppBar(title: AppStrings.customAzkar),
            BlocBuilder<CustomAzkarCubit, CustomAzkarState>(
              builder: (context, state) => switch (state) {
                CustomAzkarLoading() ||
                CustomAzkarInitial() => const CustomAzkarListSkeleton(),
                CustomAzkarError(:final message) => SliverFillRemaining(
                  hasScrollBody: false,
                  child: AppErrorView(
                    message: message,
                    onRetry: () => unawaited(
                      context.read<CustomAzkarCubit>().loadCustomCategories(),
                    ),
                  ),
                ),
                CustomAzkarEmpty() => SliverFillRemaining(
                  hasScrollBody: false,
                  child: AppStateView(
                    icon: AppIcons.empty,
                    title: AppStrings.customAzkar,
                    message: AppStrings.noCustomAzkarYet,
                    action: AppPrimaryButton(
                      label: AppStrings.addCustomAzkar,
                      onPressed: () => unawaited(
                        OpenCustomAzkarForm.andReload(
                          context,
                          reload: () async {
                            await context
                                .read<CustomAzkarCubit>()
                                .loadCustomCategories();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                CustomAzkarLoaded(:final categories) => CustomAzkarListSection(
                  categories: categories,
                ),
              },
            ),
          ],
        ),
      ),
    ),
  );
}
