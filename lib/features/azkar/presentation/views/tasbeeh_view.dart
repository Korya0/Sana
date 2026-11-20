import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_icon_button.dart';
import 'package:sana/core/widgets/overlays/app_bottom_sheet.dart';
import 'package:sana/core/widgets/slivers/common_sliver_app_bar.dart';
import 'package:sana/core/widgets/views/app_error_view.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/tasbeeh/tasbeeh_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/tasbeeh/tasbeeh_state.dart';
import 'package:sana/features/azkar/presentation/utils/haptic_feedback.dart';
import 'package:sana/features/azkar/presentation/utils/tasbeeh_actions_flow.dart';
import 'package:sana/features/azkar/presentation/utils/azkar_settings_flow.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_preset_grid.dart';
import 'package:sana/features/azkar/presentation/widgets/common/reading_settings_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/common/volume_counter_binding.dart';
import 'package:sana/features/azkar/presentation/widgets/tasbeeh/tasbeeh_loaded_body.dart';

class TasbeehView extends StatelessWidget {
  const TasbeehView({super.key, this.initialSelectedItemId});

  final String? initialSelectedItemId;

  Future<void> _openAdd(BuildContext context) async {
    await TasbeehActionsFlow.openAdd(context, context.read<TasbeehCubit>());
  }

  Future<void> _addPreset(BuildContext context, String text) async {
    await TasbeehActionsFlow.addPreset(
      context,
      context.read<TasbeehCubit>(),
      text,
    );
  }

  Future<void> _openOptions(
    BuildContext context, {
    bool showReadingSettings = true,
  }) => TasbeehActionsFlow.openOptions(
    context,
    context.read<TasbeehCubit>(),
    showReadingSettings: showReadingSettings,
    onSelect: (id) async => context.read<TasbeehCubit>().selectItem(id),
  );

  Future<void> _openReadingSettings(BuildContext context) async {
    final goToFontSize = await AppBottomSheet.show<bool>(
      context: context,
      child: BlocProvider.value(
        value: context.read<AzkarTasbeehSettingsCubit>(),
        child: const ReadingSettingsBottomSheet(),
      ),
    );
    if (goToFontSize != true || !context.mounted) return;
    await AzkarSettingsFlow.openWithGoBack(
      context,
      reopenOptions: () => _openReadingSettings(context),
    );
  }

  Future<void> _handleVolumeUp(BuildContext context) async {
    final cubit = context.read<TasbeehCubit>();
    final state = cubit.state;
    if (state is! TasbeehLoaded) return;

    final item = state.selectedItem;
    if (item == null) return;

    final result = await cubit.increment(item.id);
    if (!context.mounted) return;
    playIncrementHapticFeedback(context, result);
  }

  Future<void> _handleVolumeDown(BuildContext context) async {
    final cubit = context.read<TasbeehCubit>();
    final state = cubit.state;
    if (state is! TasbeehLoaded) return;

    final item = state.selectedItem;
    if (item == null) return;

    final changed = await cubit.decrement(item.id);
    if (!context.mounted || !changed) return;
    playDecrementHapticFeedback(context);
  }

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider<TasbeehCubit>(
        create: (context) {
          final cubit = sl<TasbeehCubit>();
          unawaited(cubit.loadItems(selectedItemId: initialSelectedItemId));
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
      builder: (context) => BlocSelector<TasbeehCubit, TasbeehState, bool>(
        selector: (state) =>
            state is TasbeehLoaded && state.selectedItem != null,
        builder: (context, canCount) => VolumeCounterBinding(
          canCount: canCount,
          onUp: () => unawaited(_handleVolumeUp(context)),
          onDown: () => unawaited(_handleVolumeDown(context)),
          child: Scaffold(
            body: CustomScrollView(
              slivers: [
                CommonSliverAppBar(
                  title: AppStrings.tasbeehTitle,
                  isPinned: true,
                  actions: [
                    // Reading settings only
                    AppIconButton(
                      icon: AppIcons.more,
                      tooltip: AppStrings.azkarTasbeehSettingsTitle,
                      onPressed: () => unawaited(_openReadingSettings(context)),
                    ),
                  ],
                ),
                BlocBuilder<TasbeehCubit, TasbeehState>(
                  builder: (context, state) => switch (state) {
                    TasbeehLoaded(:final items, :final selectedItem)
                        when items.isNotEmpty && selectedItem != null =>
                      TasbeehLoadedBody(
                        selectedItem: selectedItem,
                        onAdd: () => unawaited(_openAdd(context)),
                        onOpenList: () => unawaited(
                          _openOptions(context, showReadingSettings: false),
                        ),
                      ),
                    TasbeehLoaded() => SliverMainAxisGroup(
                      slivers: [
                        SliverPadding(
                          padding: AppSize.shp,
                          sliver: SliverToBoxAdapter(
                            child: TasbeehPresetGrid(
                              onSelect: (text) =>
                                  unawaited(_addPreset(context, text)),
                              onCustomTap: () => unawaited(_openAdd(context)),
                            ),
                          ),
                        ),
                        // Bottom gap
                        SliverToBoxAdapter(child: AppGap.h(AppSize.sbp)),
                      ],
                    ),
                    TasbeehError(:final message) => SliverFillRemaining(
                      hasScrollBody: false,
                      child: AppErrorView(
                        message: message,
                        onRetry: () =>
                            unawaited(context.read<TasbeehCubit>().loadItems()),
                      ),
                    ),
                    // Loading
                    TasbeehInitial() ||
                    TasbeehLoading() => const SliverToBoxAdapter(
                      child: SizedBox.shrink(),
                    ),
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
