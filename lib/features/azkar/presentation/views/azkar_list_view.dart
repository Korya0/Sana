// ignore_for_file: use_build_context_synchronously, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/widgets/app_toast.dart';
import 'package:sana/core/common/widgets/custom_confirmation_dialog.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category.dart';
import 'package:sana/core/common/widgets/common_sliver_app_bar.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar_list_cubit.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar_list_state.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_list_content.dart';

class AzkarListView extends StatefulWidget {
  final AzkarCategory category;

  const AzkarListView({super.key, required this.category});

  @override
  State<AzkarListView> createState() => _AzkarListViewState();
}

class _AzkarListViewState extends State<AzkarListView> {
  late List<GlobalKey> _itemKeys;

  @override
  void initState() {
    super.initState();
    _itemKeys = List.generate(widget.category.azkar.length, (_) => GlobalKey());
  }

  void _handleZikrCompleted(BuildContext context, int index) {
    _scrollToNextItem(index);
  }

  void _scrollToNextItem(int index) {
    if (index + 1 < widget.category.azkar.length) {
      Future.delayed(const Duration(milliseconds: 100), () {
        final context = _itemKeys[index + 1].currentContext;
        if (context != null) {
          Scrollable.ensureVisible(
            context,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            alignment: 0.3,
          );
        }
      });
    }
  }

  void _handleExit(BuildContext context) {
    final state = context.read<AzkarListCubit>().state;

    if (state is AzkarListInProgress) {
      final hasProgress = state.hasProgress;
      final isCompleted = state.isAllCompleted;

      if (hasProgress && !isCompleted) {
        CustomConfirmationDialog.show(
          context,
          title: 'تنبيه',
          message: 'هل تريد الخروج؟ ستفقد تقدمك الحالي في الأذكار',
          confirmText: 'خروج',
          cancelText: 'إلغاء',
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
      create: (context) => AzkarListCubit(widget.category),
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
              onPopInvoked: (didPop) async {
                if (didPop) return;
                _handleExit(context);
              },
              child: Scaffold(
                body: CustomScrollView(
                  slivers: [
                    CommonSliverAppBar(
                      title: widget.category.title,
                      onBackPressed: () => _handleExit(context),
                    ),
                    AzkarListContent(
                      category: widget.category,
                      itemKeys: _itemKeys,
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
