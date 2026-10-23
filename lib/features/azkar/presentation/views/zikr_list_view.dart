import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/buttons/app_icon_button.dart';
import 'package:sana/core/widgets/overlays/app_bottom_sheet.dart';
import 'package:sana/core/widgets/overlays/custom_confirmation_dialog.dart';
import 'package:sana/core/widgets/overlays/app_toast.dart';
import 'package:sana/core/widgets/slivers/common_sliver_app_bar.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_state.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_state.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/reading_settings/reading_settings_bottom_sheet.dart';
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
  Timer? _autoScrollTimer;
  Timer? _completionTimer;
  bool _isExiting = false;
  bool _isCompleting = false;

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

  void _scrollToNextItem(int completedIndex, AzkarCubit cubit) {
    final state = cubit.state;
    if (state is! AzkarLoaded) return;

    final nextIndex = state.findNextIncompleteIndex(completedIndex);
    if (nextIndex == null) return;

    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer(AppConstants.animationNormal300ms, () {
      if (!mounted || !_scrollController.hasClients) return;

      final position = _scrollController.position;
      final target =
          (_scrollController.offset +
                  position.viewportDimension *
                      AppConstants.azkarAutoScrollViewportFraction)
              .clamp(0.0, position.maxScrollExtent);

      unawaited(
        _scrollController.animateTo(
          target,
          duration: AppConstants.animationSlow400ms,
          curve: Curves.easeInOutCubic,
        ),
      );
    });
  }

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
      builder: (context) =>
          BlocListener<ReadingSettingsCubit, ReadingSettingsState>(
            listenWhen: (previous, current) => current is ReadingSettingsError,
            listener: (context, state) {
              if (state is ReadingSettingsError) {
                AppToast.show(
                  context,
                  state.message,
                  type: AppToastType.error,
                );
              }
            },
            child: BlocListener<AzkarCubit, AzkarState>(
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
                        buildWhen: (previous, current) =>
                            (previous is AzkarLoaded
                                ? previous.resolvedTitle
                                : null) !=
                            (current is AzkarLoaded
                                ? current.resolvedTitle
                                : null),
                        builder: (context, state) {
                          final title = state is AzkarLoaded
                              ? state.resolvedTitle
                              : widget.categoryTitle;

                          return CommonSliverAppBar(
                            title: title,
                            onBackPressed: () =>
                                unawaited(_handleExit(context)),
                            actions: [
                              AppIconButton(
                                icon: AppIcons.moreVertical,
                                tooltip: AppStrings.readingSettingsTitle,
                                onPressed: () => unawaited(
                                  AppBottomSheet.show<void>(
                                    context: context,
                                    child: ReadingSettingsBottomSheet(
                                      cubit: context
                                          .read<ReadingSettingsCubit>(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      // Body
                      ZikrListContent(
                        onRetry: () => unawaited(
                          context.read<AzkarCubit>().loadAzkar(
                            widget.categoryKey,
                            categoryTitle: widget.categoryTitle,
                          ),
                        ),
                        onItemCompleted: (index) => _scrollToNextItem(
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
  );
}
