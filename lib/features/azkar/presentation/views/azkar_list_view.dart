import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/widgets/app_toast.dart';
import 'package:sana/core/common/widgets/common_sliver_app_bar.dart';
import 'package:sana/core/common/widgets/custom_confirmation_dialog.dart';
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
      // Small delay to allow the item state to update before scrolling
      unawaited(
        Future<void>.delayed(const Duration(milliseconds: 200), () async {
          if (!mounted) return;
          if (_scrollController.hasClients) {
            // Calculate a reasonable scroll amount.
            // Since cards vary, we'll scroll down by a generous amount or animate
            // to make the next item more visible.
            final currentPosition = _scrollController.position.pixels;
            final screenHeight = MediaQuery.of(context).size.height;

            // Scroll down by 60% of screen height to bring next card into focus
            await _scrollController.animateTo(
              currentPosition + (screenHeight * 0.4),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
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
          title: 'تنبيه',
          message: 'هل تريد الخروج؟ ستفقد تقدمك الحالي في الأذكار',
          confirmText: 'خروج',
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
                  'لقد أتممت جميع الأذكار بنجاح، جعلها الله في ميزان حسناتك',
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
