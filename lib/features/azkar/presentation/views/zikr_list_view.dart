import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/router/app_routes.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/buttons/app_icon_button.dart';
import 'package:sana/core/widgets/overlays/app_bottom_sheet.dart';
import 'package:sana/core/widgets/overlays/app_toast.dart';
import 'package:sana/core/widgets/overlays/custom_confirmation_dialog.dart';
import 'package:sana/core/widgets/slivers/common_sliver_app_bar.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_state.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/common/counter_increment_result.dart';
import 'package:sana/features/azkar/presentation/utils/azkar_settings_flow.dart';
import 'package:sana/features/azkar/presentation/utils/haptic_feedback.dart';
import 'package:sana/features/azkar/presentation/widgets/common/azkar_category_actions_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/common/reading_settings_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/common/volume_counter_binding.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_list_content.dart';

class ZikrListView extends StatefulWidget {
  const ZikrListView({
    required this.categoryKey,
    required this.categoryTitle,
    super.key,
  });

  final String categoryKey;
  final String categoryTitle;

  @override
  State<ZikrListView> createState() => _ZikrListViewState();
}

class _ZikrListViewState extends State<ZikrListView> {
  late final ScrollController _scrollController;
  final Map<int, GlobalKey> _cardKeys = {};
  Timer? _autoScrollTimer;
  Timer? _completionTimer;
  bool _isExiting = false;
  bool _isCompleting = false;
  int _scrollRequest = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _completionTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  GlobalKey _cardKey(int index) =>
      _cardKeys.putIfAbsent(index, () => GlobalKey());

  void _scrollToFirstIncomplete(int completedIndex, AzkarCubit cubit) {
    final state = cubit.state;
    if (state is! AzkarLoaded) return;

    final targetIndex = state.firstIncompleteIndex;
    if (targetIndex == null) return;

    _autoScrollTimer?.cancel();
    final request = ++_scrollRequest;
    _autoScrollTimer = Timer(AppConstants.animationNormal300ms, () {
      if (!mounted) return;
      unawaited(_focusCard(targetIndex, completedIndex, request));
    });
  }

  Future<void> _focusCard(int index, int fromIndex, int request) async {
    final targetContext = _cardKey(index).currentContext;
    if (targetContext != null) {
      await _revealCard(targetContext);
      return;
    }

    if (!_scrollController.hasClients) return;

    final step =
        _scrollController.position.viewportDimension *
        AppConstants.azkarScrollSearchFraction;
    final direction = index < fromIndex ? -1 : 1;

    for (
      var attempt = 0;
      attempt < AppConstants.azkarScrollMaxSteps;
      attempt++
    ) {
      if (!mounted || request != _scrollRequest) return;

      final current = _scrollController.offset;
      final next = (current + direction * step).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      );
      if (next == current) return;

      _scrollController.jumpTo(next);
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted || request != _scrollRequest) return;

      final cardContext = _cardKey(index).currentContext;
      if (cardContext != null && cardContext.mounted) {
        await _revealCard(cardContext);
        return;
      }
    }
  }

  Future<void> _revealCard(BuildContext context) => Scrollable.ensureVisible(
    context,
    alignment: AppConstants.azkarCardFocusAlignment,
    duration: AppConstants.animationSlow400ms,
    curve: Curves.easeInOutCubic,
  );

  Future<void> _handleExit(BuildContext context) async {
    if (_isExiting) return;

    final state = context.read<AzkarCubit>().state;
    final needsConfirmation =
        state is AzkarLoaded && state.hasStarted && !state.isAllCompleted;

    if (needsConfirmation) {
      _isExiting = true;
      final shouldExit = await CustomConfirmationDialog.show(
        context: context,
        title: AppStrings.azkarExitDialogTitle,
        message: AppStrings.azkarExitDialogMessage,
        confirmText: AppStrings.azkarExitDialogConfirmText,
        cancelText: AppStrings.azkarExitDialogCancelText,
      );
      if (shouldExit != true) {
        _isExiting = false;
        return;
      }
    }

    if (!mounted || !context.mounted) return;
    _isExiting = true;
    _completionTimer?.cancel();
    Navigator.of(context).pop();
  }

  Future<void> _handleEditAzkar(BuildContext context) async {
    final cubit = context.read<AzkarCubit>();
    final state = cubit.state;
    if (state is! AzkarLoaded) return;

    final category = CustomCategoryEntity(
      id: widget.categoryKey,
      name: state.resolvedTitle,
      azkar: state.azkar,
    );

    final saved = await context.pushNamed<CustomCategoryEntity>(
      AppRoutes.customAzkarFormView,
      extra: category,
    );

    if (saved == null || !context.mounted || cubit.isClosed) return;

    cubit.applySavedCategory(saved);
  }

  Future<void> _handleDeleteCustomCategory(BuildContext context) async {
    final state = context.read<AzkarCubit>().state;
    if (state is! AzkarLoaded || !state.isCustom) return;

    final confirmed = await CustomConfirmationDialog.show(
      context: context,
      title: AppStrings.deleteCustomAzkarDialogTitle,
      message: AppStrings.deleteCustomAzkarDialogMessage,
      confirmText: AppStrings.delete,
      cancelText: AppStrings.cancel,
    );

    if (confirmed != true || !context.mounted) return;

    final result = await context.read<AzkarCubit>().deleteCustomCategory(
      widget.categoryKey,
    );
    if (!context.mounted) return;

    switch (result) {
      case Success():
        AppToast.show(
          context,
          AppStrings.customAzkarDeletedSuccess,
          type: AppToastType.success,
        );
        context.popOnce();
      case FailureResult(:final failure):
        AppToast.show(
          context,
          failure.message,
          type: AppToastType.error,
        );
    }
  }

  Future<void> _handleRestoreCategory(BuildContext context) async {
    final state = context.read<AzkarCubit>().state;
    if (state is! AzkarLoaded) return;

    final confirmed = await CustomConfirmationDialog.show(
      context: context,
      title: AppStrings.restoreCategoryDialogTitle,
      message: AppStrings.restoreCategoryDialogMessage,
      confirmText: AppStrings.restoreOriginal,
      cancelText: AppStrings.cancel,
    );

    if (confirmed != true || !context.mounted) return;

    final result = await context.read<AzkarCubit>().restoreCategory(
      widget.categoryKey,
      categoryTitle: state.resolvedTitle,
    );
    if (!context.mounted) return;

    if (result case FailureResult(:final failure)) {
      AppToast.show(context, failure.message, type: AppToastType.error);
    }
  }

  Future<void> _handleCategoryActions(BuildContext context) async {
    final state = context.read<AzkarCubit>().state;
    if (state is! AzkarLoaded) return;

    final action = await AppBottomSheet.show<AzkarCategoryAction>(
      context: context,
      child: AzkarCategoryActionsBottomSheet(
        isCustom: state.isCustom,
        canRestore: state.isModified,
      ),
    );

    if (!context.mounted || action == null) return;

    switch (action) {
      case AzkarCategoryAction.fontSize:
        await _openAzkarTasbeehSettings(context);
      case AzkarCategoryAction.edit:
        await _handleEditAzkar(context);
      case AzkarCategoryAction.restore:
        await _handleRestoreCategory(context);
      case AzkarCategoryAction.delete:
        await _handleDeleteCustomCategory(context);
    }
  }

  Future<void> _openAzkarTasbeehSettings(BuildContext context) =>
      AzkarSettingsFlow.openWithGoBack(
        context,
        reopenOptions: () => _handleCategoryActions(context),
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

  void _handleVolumeUp(BuildContext context) {
    final cubit = context.read<AzkarCubit>();
    final state = cubit.state;
    if (state is! AzkarLoaded) return;

    final index = state.firstIncompleteIndex;
    if (index == null) return;

    final result = cubit.incrementZikr(state.azkar[index].id);
    playIncrementHapticFeedback(context, result);
    if (result is CounterCompleted) {
      _scrollToFirstIncomplete(index, cubit);
    }
  }

  void _handleVolumeDown(BuildContext context) {
    final cubit = context.read<AzkarCubit>();
    final state = cubit.state;
    if (state is! AzkarLoaded) return;

    final index = state.firstIncompleteIndex;
    if (index == null) return;

    final changed = cubit.decrementZikr(state.azkar[index].id);
    if (changed) playDecrementHapticFeedback(context);
  }

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider<AzkarCubit>(
        create: (context) {
          final cubit = sl<AzkarCubit>();
          unawaited(
            cubit.loadAzkar(
              widget.categoryKey,
              categoryTitle: widget.categoryTitle,
            ),
          );
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
      builder: (context) => BlocSelector<AzkarCubit, AzkarState, bool>(
        selector: (state) => state is AzkarLoaded && !state.isAllCompleted,
        builder: (context, canCount) => VolumeCounterBinding(
          canCount: canCount,
          onUp: () => _handleVolumeUp(context),
          onDown: () => _handleVolumeDown(context),
          child: BlocListener<AzkarCubit, AzkarState>(
            listenWhen: (previous, current) =>
                previous is AzkarLoaded &&
                current is AzkarLoaded &&
                !previous.isAllCompleted &&
                current.isAllCompleted &&
                // Only auto-close after tapping the final repetition.
                identical(previous.azkar, current.azkar),
            listener: (context, state) {
              if (state is! AzkarLoaded ||
                  !state.isAllCompleted ||
                  _isCompleting ||
                  _isExiting) {
                return;
              }

              _isCompleting = true;
              AppToast.show(
                context,
                AppStrings.azkarCompletedMessage,
                type: AppToastType.success,
              );

              _completionTimer?.cancel();
              _completionTimer = Timer(AppConstants.animationSlower500ms, () {
                if (!mounted || !context.mounted) return;
                final route = ModalRoute.of(context);
                if (route != null && !route.isCurrent) return;
                Navigator.of(context).pop();
              });
            },
            child: PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) {
                if (didPop) return;
                unawaited(_handleExit(context));
              },
              child: Scaffold(
                body: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    // Header
                    BlocBuilder<AzkarCubit, AzkarState>(
                      buildWhen: (previous, current) {
                        final prevLoaded = previous is AzkarLoaded
                            ? previous
                            : null;
                        final currLoaded = current is AzkarLoaded
                            ? current
                            : null;
                        return prevLoaded?.resolvedTitle !=
                                currLoaded?.resolvedTitle ||
                            prevLoaded?.isCustom != currLoaded?.isCustom ||
                            prevLoaded?.isModified != currLoaded?.isModified;
                      },
                      builder: (context, state) {
                        final title = state is AzkarLoaded
                            ? state.resolvedTitle
                            : widget.categoryTitle;
                        final isLoaded = state is AzkarLoaded;

                        return CommonSliverAppBar(
                          title: title,
                          isPinned: true,
                          onBackPressed: () => unawaited(_handleExit(context)),
                          actions: [
                            // Edit / restore / delete
                            AppIconButton(
                              icon: AppIcons.info,
                              tooltip: AppStrings.editZikr,
                              onPressed: isLoaded
                                  ? () => unawaited(
                                      _handleCategoryActions(context),
                                    )
                                  : null,
                            ),
                            // Reading settings
                            AppIconButton(
                              icon: AppIcons.more,
                              tooltip: AppStrings.azkarTasbeehSettingsTitle,
                              onPressed: () =>
                                  unawaited(_openReadingSettings(context)),
                            ),
                          ],
                        );
                      },
                    ),

                    // Body
                    ZikrListContent(
                      categoryKey: widget.categoryKey,
                      cardKeyBuilder: _cardKey,
                      onRetry: () => unawaited(
                        context.read<AzkarCubit>().loadAzkar(
                          widget.categoryKey,
                          categoryTitle: widget.categoryTitle,
                        ),
                      ),
                      onItemCompleted: (index) => _scrollToFirstIncomplete(
                        index,
                        context.read<AzkarCubit>(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
