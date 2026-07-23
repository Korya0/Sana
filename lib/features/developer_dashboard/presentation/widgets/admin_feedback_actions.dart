import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/constants/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/developer_dashboard/domain/entities/feedback_entity.dart';
import 'package:sana/features/developer_dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:sana/features/developer_dashboard/presentation/widgets/share_card/feedback_share_card.dart';
import 'package:sana/features/sharing/presentation/combined_share_copy_button.dart';
import 'package:sana/features/sharing/presentation/utils/app_share.dart';

class AdminFeedbackActions extends StatelessWidget {
  const AdminFeedbackActions({
    required this.feedback,
    super.key,
  });

  final FeedbackEntity feedback;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomAppDivider(),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.v16,
            vertical: AppSpacing.v8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppDeleteButton(
                onPressed: () => _confirmDelete(context),
              ),

              CombinedShareCopyButton(
                onSharePressed: () => _shareFeedback(context),
                onCopyPressed: () => _copyFeedbackToClipboard(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    await CustomConfirmationDialog.show(
      context,
      title: AppStrings.deleteConfirmation,
      message: AppStrings.deleteFeedbackConfirmationMessage,
      confirmText: AppStrings.delete,
      isDestructive: true,
      onConfirm: () {
        context.read<DashboardCubit>().deleteFeedback(feedback.id);
      },
    );
  }

  Future<void> _shareFeedback(BuildContext context) async {
    if (!context.mounted) return;
    try {
      await AppShare.shareWidgetAsImage(
        context: context,
        widget: FeedbackShareCard(feedback: feedback),
        imageName: 'feedback_${feedback.id}',
      );
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.localError(
          'Share Error',
          error: e,
          stackTrace: stack,
        ),
      );
    }
  }

  Future<void> _copyFeedbackToClipboard(BuildContext context) async {
    if (!context.mounted) return;
    try {
      await Clipboard.setData(ClipboardData(text: feedback.message));
    } on Object catch (e, stack) {
      if (context.mounted) {
        AppToast.show(
          context,
          AppStrings.copyError,
          type: AppToastType.error,
        );
      }
      unawaited(
        AppLogger.localError(
          'Copy Error',
          error: e,
          stackTrace: stack,
        ),
      );
    }
  }
}
