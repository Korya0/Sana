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
import 'package:sana/core/widgets/buttons/app_icon_button.dart';
import 'package:sana/core/widgets/overlays/app_bottom_sheet.dart';
import 'package:sana/core/widgets/overlays/app_toast.dart';
import 'package:sana/core/widgets/overlays/custom_confirmation_dialog.dart';
import 'package:sana/core/widgets/slivers/common_sliver_app_bar.dart';
import 'package:sana/features/azkar/domain/repositories/custom_azkar_repository.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_state.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar/add_zikr_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar/custom_category_actions_bottom_sheet.dart';
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

  bool get _isCustomCategory => widget.categoryKey.startsWith('custom_');

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

  Future<void> _handleAddZikr(BuildContext context, String currentTitle) async {
    await AppBottomSheet.show<void>(
      context: context,
      child: AddZikrBottomSheet(
        onSave: (newZikr) async {
          final cubit = context.read<AzkarCubit>();
          final success = await cubit.addZikr(
            newZikr,
            categoryKey: widget.categoryKey,
            categoryTitle: currentTitle,
          );
          if (success && context.mounted) {
            AppToast.show(
              context,
              AppStrings.zikrAddedSuccess,
              type: AppToastType.success,
            );
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_scrollController.hasClients) {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: AppConstants.animationNormal300ms,
                  curve: Curves.easeOut,
                );
              }
            });
          }
        },
      ),
    );
  }

  Future<void> _handleCustomCategoryOptions(
    BuildContext context,
    String currentTitle,
  ) async {
    final isBuiltIn = !_isCustomCategory;
    final action = await AppBottomSheet.show<CustomCategoryAction>(
      context: context,
      child: CustomCategoryActionsBottomSheet(
        title: currentTitle,
        isBuiltIn: isBuiltIn,
      ),
    );

    if (!context.mounted || action == null) return;

    switch (action) {
      case CustomCategoryAction.edit:
        final repo = sl<CustomAzkarRepository>();
        final result = await repo.getCustomCategoryById(widget.categoryKey);
        if (!context.mounted) return;

        final customEntity = switch (result) {
          Success(data: final entity) => entity,
          _ => null,
        };

        if (customEntity != null) {
          final updated = await context.pushNamed<bool>(
            AppRoutes.customZikrFormPath,
            extra: customEntity,
          );
          if (updated == true && context.mounted) {
            final updatedResult =
                await repo.getCustomCategoryById(widget.categoryKey);
            final newTitle = switch (updatedResult) {
              Success(data: final updatedEntity?) => updatedEntity.name,
              _ => widget.categoryTitle,
            };
            if (context.mounted) {
              unawaited(
                context.read<AzkarCubit>().loadAzkar(
                  widget.categoryKey,
                  categoryTitle: newTitle,
                ),
              );
            }
          }
        }
      case CustomCategoryAction.delete:
        final confirmed = await CustomConfirmationDialog.show(
          context: context,
          title: AppStrings.deleteCustomZikrDialogTitle,
          message: AppStrings.deleteCustomZikrDialogMessage,
          confirmText: AppStrings.delete,
          cancelText: AppStrings.cancel,
        );

        if (confirmed == true && context.mounted) {
          final repo = sl<CustomAzkarRepository>();
          await repo.deleteCustomCategory(widget.categoryKey);
          if (context.mounted) {
            AppToast.show(
              context,
              AppStrings.customZikrDeletedSuccess,
              type: AppToastType.success,
            );
            Navigator.of(context).pop();
          }
        }
      case CustomCategoryAction.reset:
        final confirmed = await CustomConfirmationDialog.show(
          context: context,
          title: AppStrings.resetCategoryDialogTitle,
          message: AppStrings.resetCategoryDialogMessage,
          confirmText: AppStrings.resetCategoryToDefault,
          cancelText: AppStrings.cancel,
        );

        if (confirmed == true && context.mounted) {
          await context.read<AzkarCubit>().resetCategory(
            widget.categoryKey,
            categoryTitle: currentTitle,
          );
          if (context.mounted) {
            AppToast.show(
              context,
              AppStrings.resetCategorySuccess,
              type: AppToastType.success,
            );
          }
        }
    }
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
            current.isAllCompleted,
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
                // App bar
                BlocBuilder<AzkarCubit, AzkarState>(
                  buildWhen: (previous, current) {
                    final prevLoaded =
                        previous is AzkarLoaded ? previous : null;
                    final currLoaded = current is AzkarLoaded ? current : null;
                    return prevLoaded?.resolvedTitle !=
                            currLoaded?.resolvedTitle ||
                        prevLoaded?.isCustom != currLoaded?.isCustom;
                  },
                  builder: (context, state) {
                    final title = state is AzkarLoaded
                        ? state.resolvedTitle
                        : widget.categoryTitle;
                    final isCustom = state is AzkarLoaded
                        ? state.isCustom
                        : _isCustomCategory;

                    return CommonSliverAppBar(
                      title: title,
                      isPinned: true,
                      onBackPressed: () => unawaited(_handleExit(context)),
                      actions: [
                        AppIconButton(
                          icon: AppIcons.add,
                          tooltip: AppStrings.addZikr,
                          onPressed: () => unawaited(
                            _handleAddZikr(context, title),
                          ),
                        ),
                        if (isCustom)
                          AppIconButton(
                            icon: AppIcons.moreVertical,
                            tooltip: AppStrings.customZikrActionsTitle,
                            onPressed: () => unawaited(
                              _handleCustomCategoryOptions(
                                context,
                                title,
                              ),
                            ),
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
