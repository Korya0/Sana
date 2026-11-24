import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/router/app_routes.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/buttons/app_primary_button.dart';
import 'package:sana/core/widgets/views/app_state_view.dart';
import 'package:sana/features/azkar/presentation/cubits/tasbeeh/tasbeeh_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/tasbeeh/tasbeeh_state.dart';
import 'package:sana/features/azkar/presentation/utils/tasbeeh_actions_flow.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_tasbeeh_home/tasbeeh/tasbeeh_recent_item.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_preset_grid.dart';
import 'package:sana/features/azkar/presentation/widgets/tasbeeh/tasbeeh_preset_grid_skeleton.dart';

class TasbeehHomeCard extends StatelessWidget {
  const TasbeehHomeCard({super.key});

  Future<void> _openAdd(BuildContext context) async {
    final cubit = context.read<TasbeehCubit>();
    final id = await TasbeehActionsFlow.openAdd(context, cubit);
    if (id == null || !context.mounted) return;

    await _openScreen(context, cubit, selectedItemId: id);
  }

  Future<void> _addPreset(BuildContext context, String text) async {
    final cubit = context.read<TasbeehCubit>();
    final id = await TasbeehActionsFlow.addPreset(context, cubit, text);
    if (id == null || !context.mounted) return;

    await _openScreen(context, cubit, selectedItemId: id);
  }

  Future<void> _openScreen(
    BuildContext context,
    TasbeehCubit cubit, {
    String? selectedItemId,
  }) async {
    await context.pushNamed(AppRoutes.tasbeehView, extra: selectedItemId);
    if (context.mounted) {
      unawaited(cubit.loadItems());
    }
  }

  Future<void> _openAll(BuildContext context) {
    final cubit = context.read<TasbeehCubit>();

    return TasbeehActionsFlow.openOptions(
      context,
      cubit,
      showReadingSettings: false,
      onSelect: (id) => _openScreen(context, cubit, selectedItemId: id),
      onAdded: (id) => _openScreen(context, cubit, selectedItemId: id),
    );
  }

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: AppSize.contentMaxWidth),
      child: BlocProvider<TasbeehCubit>(
        create: (context) {
          final cubit = sl<TasbeehCubit>();
          unawaited(cubit.loadItems());
          return cubit;
        },
        child: BlocBuilder<TasbeehCubit, TasbeehState>(
          builder: (context, state) {
            final cubit = context.read<TasbeehCubit>();

            // Most recent item
            final recentItem = state is TasbeehLoaded && state.items.isNotEmpty
                ? state.recentItems.first
                : null;

            return switch (state) {
              // No saved items
              TasbeehLoaded() when recentItem == null => TasbeehPresetGrid(
                onSelect: (text) => unawaited(_addPreset(context, text)),
                onCustomTap: () => unawaited(_openAdd(context)),
              ),

              // Recent item
              TasbeehLoaded() => TasbeehRecentItem(
                item: recentItem!,
                onContinue: () => unawaited(
                  _openScreen(context, cubit, selectedItemId: recentItem.id),
                ),
                onOpenAll: () => unawaited(_openAll(context)),
              ),

              // Error
              TasbeehError(:final message) => AppStateView(
                icon: AppIcons.error,
                title: AppStrings.tasbeehLoadError,
                message: message,
                // Content-sized inside the home card; no viewport floor.
                fillHeight: 0,
                action: AppPrimaryButton(
                  label: AppStrings.tryAgain,
                  onPressed: () => unawaited(cubit.loadItems()),
                ),
              ),

              // Loading
              TasbeehInitial() ||
              TasbeehLoading() => const TasbeehPresetGridSkeleton(),
            };
          },
        ),
      ),
    ),
  );
}
