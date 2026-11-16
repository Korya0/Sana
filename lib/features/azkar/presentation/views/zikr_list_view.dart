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
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_categories/azkar_category_actions_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/reading_settings/reading_settings_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_list_content.dart';

class ZikrListView extends StatefulWidget {
  // Creates view
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

  // Initializes state
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  // Disposes state
  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _completionTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  // Resolves key
  GlobalKey _cardKey(int index) =>
      _cardKeys.putIfAbsent(index, () => GlobalKey());

  // Scrolls to incomplete
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

  // Focuses card
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

  // Reveals card
  Future<void> _revealCard(BuildContext context) => Scrollable.ensureVisible(
    context,
    alignment: AppConstants.azkarCardFocusAlignment,
    duration: AppConstants.animationSlow400ms,
    curve: Curves.easeInOutCubic,
  );

  // Handles exit
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

  // Opens edit form
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
      AppRoutes.zikrFormView,
      extra: category,
    );

    if (saved == null || !context.mounted) return;

    final latestState = cubit.state;
    if (latestState is! AzkarLoaded) return;

    cubit.applyCategoryUpdate(
      saved.azkar,
      isModified: !latestState.isCustom,
      resolvedTitle: saved.name,
    );
  }

  // Deletes custom category
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

  // Restores category
  Future<void> _handleRestoreCategory(BuildContext context) async {
    final state = context.read<AzkarCubit>().state;
    if (state is! AzkarLoaded) return;

    final confirmed = await CustomConfirmationDialog.show(
      context: context,
      title: AppStrings.resetCategoryDialogTitle,
      message: AppStrings.resetCategoryDialogMessage,
      confirmText: AppStrings.restoreOriginal,
      cancelText: AppStrings.cancel,
    );

    if (confirmed != true || !context.mounted) return;

    final result = await context.read<AzkarCubit>().resetCategory(
      widget.categoryKey,
      categoryTitle: state.resolvedTitle,
    );
    if (!context.mounted) return;

    if (result case FailureResult(:final failure)) {
      AppToast.show(context, failure.message, type: AppToastType.error);
    }
  }

  // Opens category actions
  Future<void> _handleCategoryActions(BuildContext context) async {
    final state = context.read<AzkarCubit>().state;
    if (state is! AzkarLoaded) return;

    final action = await AppBottomSheet.show<AzkarCategoryAction>(
      context: context,
      child: AzkarCategoryActionsBottomSheet(
        isCustom: state.isCustom,
        canRestore: state.isModified,
        showReadingSettings: true,
        readingSettingsCubit: context.read<ReadingSettingsCubit>(),
      ),
    );

    if (!context.mounted || action == null) return;

    switch (action) {
      case AzkarCategoryAction.fontSize:
        await _openReadingSettings(context);
      case AzkarCategoryAction.edit:
        await _handleEditAzkar(context);
      case AzkarCategoryAction.restore:
        await _handleRestoreCategory(context);
      case AzkarCategoryAction.delete:
        await _handleDeleteCustomCategory(context);
    }
  }

  // Opens settings
  Future<void> _openReadingSettings(BuildContext context) async {
    final goBack = await AppBottomSheet.show<bool>(
      context: context,
      child: ReadingSettingsBottomSheet(
        cubit: context.read<ReadingSettingsCubit>(),
        showBackButton: true,
      ),
    );

    if (goBack != true || !context.mounted) return;
    await _handleCategoryActions(context);
  }

  // Builds view
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
      BlocProvider<ReadingSettingsCubit>(
        create: (context) {
          final cubit = sl<ReadingSettingsCubit>();
          unawaited(cubit.loadSettings());
          return cubit;
        },
      ),
    ],
    child: Builder(
      builder: (context) => BlocListener<AzkarCubit, AzkarState>(
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
                    final currLoaded = current is AzkarLoaded ? current : null;
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
                        // Options action
                        AppIconButton(
                          icon: AppIcons.tuning,
                          tooltip: AppStrings.azkarOptions,
                          onPressed: isLoaded
                              ? () => unawaited(
                                  _handleCategoryActions(context),
                                )
                              : null,
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
  );
}
