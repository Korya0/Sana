import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/buttons/app_icon_button.dart';
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

  // Creation lives here so the home options sheet only needs the management entry.
  Future<void> _openCreate(BuildContext context) =>
      OpenCustomAzkarForm.andReload(
        context,
        reload: () async {
          await context.read<CustomAzkarCubit>().loadCustomCategories();
        },
      );

  @override
  Widget build(BuildContext context) => BlocProvider<CustomAzkarCubit>(
    create: (context) {
      final cubit = sl<CustomAzkarCubit>();
      unawaited(cubit.loadCustomCategories());
      return cubit;
    },
    child: Scaffold(
      body: CustomScrollView(
        slivers: [
          BlocSelector<CustomAzkarCubit, CustomAzkarState, bool>(
            selector: (state) =>
                state is CustomAzkarLoaded && state.categories.isNotEmpty,
            builder: (context, hasItems) => CommonSliverAppBar(
              title: AppStrings.customAzkar,
              // Create action only when the list has items; the empty state
              // already offers the same action in the body.
              actions: hasItems
                  ? [
                      AppIconButton(
                        icon: AppIcons.add,
                        tooltip: AppStrings.addCustomAzkar,
                        onPressed: () => unawaited(_openCreate(context)),
                      ),
                    ]
                  : null,
            ),
          ),
          BlocBuilder<CustomAzkarCubit, CustomAzkarState>(
            builder: (context, state) => switch (state) {
              CustomAzkarLoading() ||
              CustomAzkarInitial() => const _DelayedCustomAzkarListSkeleton(),
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
                    onPressed: () => unawaited(_openCreate(context)),
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
  );
}

class _DelayedCustomAzkarListSkeleton extends StatefulWidget {
  const _DelayedCustomAzkarListSkeleton();

  @override
  State<_DelayedCustomAzkarListSkeleton> createState() =>
      _DelayedCustomAzkarListSkeletonState();
}

class _DelayedCustomAzkarListSkeletonState
    extends State<_DelayedCustomAzkarListSkeleton> {
  static const _delay = Duration(milliseconds: 150);
  bool _showSkeleton = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(_delay, () {
      if (mounted) {
        setState(() => _showSkeleton = true);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _showSkeleton
      ? const CustomAzkarListSkeleton()
      : const SliverToBoxAdapter(child: SizedBox.shrink());
}
