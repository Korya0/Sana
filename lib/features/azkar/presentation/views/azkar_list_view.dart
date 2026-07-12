import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/di/service_locator.dart';


import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_state.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_state.dart';
import 'package:sana/features/azkar/presentation/views/reading_settings/reading_settings_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_list_content.dart';
import 'package:solar_icons/solar_icons.dart';

class AzkarListView extends StatefulWidget {
  const AzkarListView({
    required this.categoryId,
    required this.categoryTitle,
    super.key,
  });
  final int categoryId;
  final String categoryTitle;

  @override
  State<AzkarListView> createState() => _AzkarListViewState();
}

class _AzkarListViewState extends State<AzkarListView> {
  late ScrollController _scrollController;
  bool _isPopping = false;
  bool _canPop = false;

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

    final nextIndex = state.nextIncompleteIndex(completedIndex);

    if (nextIndex == null) return;

    Future<void>.delayed(const Duration(milliseconds: 300), () {
      if (!mounted || !_scrollController.hasClients) return;

      final screenHeight = MediaQuery.sizeOf(context).height;
      final currentPosition = _scrollController.offset;
      final maxScroll = _scrollController.position.maxScrollExtent;

      final scrollAmount = screenHeight * 0.35;
      final targetOffset = (currentPosition + scrollAmount).clamp(
        0.0,
        maxScroll,
      );

      unawaited(
        _scrollController.animateTo(
          targetOffset,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        ),
      );
    });
  }

  Future<void> _handleExit(BuildContext context) async {
    final state = context.read<AzkarCubit>().state;
    final router = GoRouter.of(context);

    if (state is AzkarLoaded) {
      if (state.hasStarted && !state.isAllCompleted) {
        await CustomConfirmationDialog.show(
          context,
          title: AppStrings.azkarExitDialogTitle,
          message: AppStrings.azkarExitDialogMessage,
          confirmText: AppStrings.azkarExitDialogConfirmText,
          cancelText: AppStrings.azkarExitDialogCancelText,
          onConfirm: () {
            setState(() => _canPop = true);
            router.pop();
          },
        );
      } else {
        setState(() => _canPop = true);
        router.pop();
      }
    } else {
      setState(() => _canPop = true);
      router.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AzkarCubit>(
          create: (context) {
            final cubit = sl<AzkarCubit>();
            unawaited(cubit.loadAzkar(widget.categoryId, fallbackTitle: widget.categoryTitle));
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
        builder: (context) {
          return BlocListener<ReadingSettingsCubit, ReadingSettingsState>(
            listenWhen: (previous, current) => current is ReadingSettingsError,
            listener: (context, state) {
              if (state is ReadingSettingsError) {
                AppToast.show(context, state.message);
              }
            },
            child: BlocListener<AzkarCubit, AzkarState>(
              listenWhen: (previous, current) {
                if (previous is AzkarLoaded && current is AzkarLoaded) {
                  return !previous.isAllCompleted && current.isAllCompleted;
                }
                return false;
              },
              listener: (context, state) {
                if (state is AzkarLoaded &&
                    state.isAllCompleted &&
                    !_isPopping) {
                  _isPopping = true;
                  AppToast.show(
                    context,
                    AppStrings.azkarCompletedMessage,
                  );
                  unawaited(
                    Future<void>.delayed(
                      const Duration(milliseconds: 500),
                    ).then((_) {
                      if (context.mounted) {
                        setState(() => _canPop = true);
                        context.pop();
                      }
                    }),
                  );
                }
              },
              child: PopScope(
                canPop: _canPop,
                onPopInvokedWithResult: (didPop, result) async {
                  if (didPop) return;
                  await _handleExit(context);
                },
                child: Scaffold(
                  body: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      BlocBuilder<AzkarCubit, AzkarState>(
                        builder: (context, state) {
                          final title = state is AzkarLoaded 
                              ? state.resolvedTitle 
                              : widget.categoryTitle;
                          return CommonSliverAppBar(
                            title: title,
                            onBackPressed: () {
                              unawaited(_handleExit(context));
                            },
                            actions: [
                              IconButton(
                                icon: const Icon(SolarIconsOutline.tuning),
                                onPressed: () {
                                  unawaited(
                                    showCustomBottomSheet(
                                      context,
                                      title: AppStrings.readingSettingsTitle,
                                      child: ReadingSettingsBottomSheet(
                                        cubit: context.read<ReadingSettingsCubit>(),
                                        azkarId: widget.categoryId.toString(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                      AzkarListContent(
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
          );
        },
      ),
    );
  }
}
