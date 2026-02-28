import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/widgets/app_toast.dart';
import 'package:sana/core/common/widgets/custom_app_divider.dart';
import 'package:sana/core/common/widgets/custom_confirmation_dialog.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/sharing/logic/widget_to_image.dart';
import 'package:sana/core/sharing/presentation/combined_share_copy_button.dart';
import 'package:sana/features/developer_dashboard/data/models/dashboard_feedback_model.dart';
import 'package:sana/features/developer_dashboard/presentation/controller/dashboard_cubit.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Delete Button
              IconButton(
                onPressed: () => _confirmDelete(context),
                icon: const Icon(SolarIconsOutline.trashBinTrash),
                color: Colors.redAccent,
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
      message: 'هل أنت متأكد من رغبتك في حذف هذا الاقتراح بشكل نهائي؟',
      confirmText: AppStrings.delete,
      isDestructive: true,
      onConfirm: () {
        context.read<DashboardCubit>().deleteFeedback(feedback.id);
        AppToast.show(context, AppStrings.deletedSuccessfully);
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
      Clipboard.setData(ClipboardData(text: feedback.message)).then(
        (_) {
          if (context.mounted) {
            AppToast.show(context, AppStrings.copy);
          }
        },
      ),
    );
  }
}
