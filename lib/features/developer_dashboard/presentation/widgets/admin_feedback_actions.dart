import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/decorations/custom_app_divider.dart';
import 'package:sana/core/common/overlays/dialog/custom_confirmation_dialog.dart';
import 'package:sana/core/common/overlays/toast/app_toast.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/services/sharing/logic/widget_to_image.dart';
import 'package:sana/core/services/sharing/presentation/combined_share_copy_button.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/features/developer_dashboard/data/models/dashboard_feedback_model.dart';
import 'package:sana/features/developer_dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:solar_icons/solar_icons.dart';

class AdminFeedbackActions extends StatelessWidget {
  const AdminFeedbackActions({
    required this.feedback,
    required this.shareChild,
    super.key,
  });

  final DashboardFeedbackModel feedback;
  final Widget shareChild;

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
              // Delete Button
              IconButton(
                onPressed: () => _confirmDelete(context),
                icon: const Icon(
                  SolarIconsOutline.trashBinTrash,
                  color: AppColors.iconRed,
                ),
                color: AppColors.red,
              ),

              // Share & Copy Button
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
        AppToast.show(
          context,
          AppStrings.deletedSuccessfully,
        );
      },
    );
  }

  void _shareFeedback(BuildContext context) {
    unawaited(
      WidgetToImage.shareWidget(
        context: context,
        widget: shareChild,
        imageName: 'feedback_${feedback.id}',
      ),
    );
  }

  void _copyFeedbackToClipboard(BuildContext context) {
    unawaited(
      Clipboard.setData(ClipboardData(text: feedback.message)),
    );
  }
}
