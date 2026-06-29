import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar_list_cubit.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar_list_state.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_list_content.dart';

class AzkarListView extends StatefulWidget {
  const AzkarListView({required this.category, super.key});
  final AzkarCategoryModel category;

  @override
  State<AzkarListView> createState() => _AzkarListViewState();
}

class _AzkarListViewState extends State<AzkarListView> {
  late ScrollController _scrollController;

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

  void _handleZikrCompleted(BuildContext context, int index) {
    _scrollToNextItem(index);
  }

  void _scrollToNextItem(int index) {
    if (index + 1 < widget.category.array.length) {
      unawaited(
        Future<void>.delayed(const Duration(milliseconds: 300), () async {
          if (!mounted) return;
          if (_scrollController.hasClients) {
            final screenHeight = MediaQuery.sizeOf(context).height;
            final currentPosition = _scrollController.offset;
            final maxScroll = _scrollController.position.maxScrollExtent;

            // Calculate target: scroll by a bit less than half screen,
            // but don't exceed max scroll.
            final scrollAmount = screenHeight * 0.35;
            final targetOffset = (currentPosition + scrollAmount).clamp(
              0.0,
              maxScroll,
            );

            await _scrollController.animateTo(
              targetOffset,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOutCubic,
            );
          }
        }),
      );
    }
  }

  Future<void> _handleExit(BuildContext context) async {
    final state = context.read<AzkarListCubit>().state;

    if (state is AzkarListInProgress) {
      final hasProgress = state.hasProgress;
      final isCompleted = state.isAllCompleted;

      if (hasProgress && !isCompleted) {
        await CustomConfirmationDialog.show(
          context,
          title: AppStrings.azkarExitDialogTitle,
          message: AppStrings.azkarExitDialogMessage,
          confirmText: AppStrings.azkarExitDialogConfirmText,
          cancelText: AppStrings.azkarExitDialogCancelText,
          onConfirm: () {
            context.pop();
          },
        );
      } else {
        context.pop();
      }
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AzkarListCubit()..loadAzkar(widget.category),
      child: Builder(
        builder: (context) {
          return BlocListener<AzkarListCubit, AzkarListState>(
            listener: (context, state) {
              if (state is AzkarListCompleted) {
                AppToast.show(
                  context,
                  AppStrings.azkarCompletedMessage,
                  seconds: 3,
                );
                context.pop();
              }
            },
            child: PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) async {
                if (didPop) return;
                await _handleExit(context);
              },
              child: Scaffold(
                body: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    CommonSliverAppBar(
                      title: widget.category.category,
                      onBackPressed: () => unawaited(_handleExit(context)),
                    ),
                    AzkarListContent(
                      category: widget.category,
                      onCompleted: (index) =>
                          _handleZikrCompleted(context, index),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
