import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_icon_button.dart';
import 'package:sana/core/widgets/buttons/app_primary_button.dart';
import 'package:sana/core/widgets/slivers/common_sliver_app_bar.dart';
import 'package:sana/core/widgets/views/app_error_view.dart';
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
                child: _CustomAzkarEmptyView(
                  onCreate: () => unawaited(_openCreate(context)),
                ),
              ),
              CustomAzkarLoaded(:final categories) => SliverLayoutBuilder(
                builder: (context, constraints) {
                  // Center and cap the list at contentMaxWidth on tablets,
                  // keeping the sliver structure intact.
                  final extra =
                      (constraints.crossAxisExtent - AppSize.contentMaxWidth) /
                      2;
                  final horizontal = extra > 0 ? extra : 0.0;
                  return SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: horizontal),
                    sliver: CustomAzkarListSection(categories: categories),
                  );
                },
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
  static const _delay = AppConstants.customAzkarSkeletonDelay150ms;
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

class _CustomAzkarEmptyView extends StatelessWidget {
  const _CustomAzkarEmptyView({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.p24),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.p24,
          vertical: AppSize.p32,
        ),
        decoration: BoxDecoration(
          color: context.color.secondaryScaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(AppSize.r16),
          border: Border.all(
            color: context.color.dividerColor,
            width: AppSize.borderWidth,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppSize.w52,
              height: AppSize.w52,
              decoration: BoxDecoration(
                color: context.color.primary.withValues(
                  alpha: AppConstants.opacitySoft,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  AppIcons.adhkar,
                  size: AppSize.icon24,
                  color: context.color.primary,
                ),
              ),
            ),
            AppGap.h(AppSize.p16),
            Text(
              AppStrings.noCustomAzkarYet,
              textAlign: TextAlign.center,
              style: AppTextStyles.font14W700Primary(context),
            ),
            AppGap.h(AppSize.p20),
            AppPrimaryButton(
              label: AppStrings.addCustomAzkar,
              onPressed: onCreate,
            ),
          ],
        ),
      ),
    ),
  );
}
