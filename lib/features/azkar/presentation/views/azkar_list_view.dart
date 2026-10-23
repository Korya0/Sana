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
import 'package:sana/features/azkar/presentation/widgets/azkar_list_content.dart';
import 'package:sana/features/azkar/presentation/widgets/reading_settings/reading_settings_bottom_sheet.dart';

class AzkarListView extends StatefulWidget {
  const AzkarListView({
    required this.categoryKey,
    required this.categoryTitle,
    super.key,
  });

  final String categoryKey;
  final String categoryTitle;

  @override
  State<AzkarListView> createState() => _AzkarListViewState();
}

class _AzkarListViewState extends State<AzkarListView> {
  late final ScrollController _scrollController;
  bool _canPop = false;
  bool _isPopping = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToNextItem(int completedIndex, AzkarCubit cubit) {
    final state = cubit.state;
    if (state is! AzkarLoaded) return;

    final nextIndex = state.findNextIncompleteIndex(completedIndex);
    if (nextIndex == null) return;

    unawaited(
      Future<void>.delayed(AppConstants.animationNormal300ms, () {
        if (!mounted || !_scrollController.hasClients) return;

        final screenHeight = MediaQuery.sizeOf(context).height;
        final target =
            (_scrollController.offset +
                    screenHeight * AppConstants.azkarAutoScrollViewportFraction)
                .clamp(0.0, _scrollController.position.maxScrollExtent);

        unawaited(
          _scrollController.animateTo(
            target,
            duration: AppConstants.animationSlow400ms,
            curve: Curves.easeInOutCubic,
          ),
        );
      }),
    );
  }

  Future<void> _handleExit(BuildContext context) async {
    final state = context.read<AzkarCubit>().state;

    if (state is AzkarLoaded && state.hasStarted && !state.isAllCompleted) {
      final shouldExit = await CustomConfirmationDialog.show(
        context: context,
        title: AppStrings.azkarExitDialogTitle,
        message: AppStrings.azkarExitDialogMessage,
        confirmText: AppStrings.azkarExitDialogConfirmText,
        cancelText: AppStrings.azkarExitDialogCancelText,
      );
      if (shouldExit != true) return;
    }

    if (!mounted || !context.mounted) return;
    setState(() => _canPop = true);
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
                    _isPopping) {
                  return;
                }

                _isPopping = true;
                AppToast.show(
                  context,
                  AppStrings.azkarCompletedMessage,
                  type: AppToastType.success,
                );

                unawaited(
                  Future<void>.delayed(AppConstants.animationSlower500ms).then((
                    _,
                  ) {
                    if (!mounted || !context.mounted) return;
                    setState(() => _canPop = true);
                    Navigator.of(context).pop();
                  }),
                );
              },
              child: PopScope(
                canPop: _canPop,
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
                      AzkarListContent(
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
