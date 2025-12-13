// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';

class CustomConfirmationDialog extends StatelessWidget {
  final String? title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;
  final bool showCancelButton;

  const CustomConfirmationDialog({
    super.key,
    this.title,
    required this.message,
    required this.confirmText,
    this.cancelText = 'إلغاء',
    required this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
    this.showCancelButton = true,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmText,
    String cancelText = 'إلغاء',
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    bool isDestructive = false,
    bool showCancelButton = true,
  }) {
    return showDialog(
      context: context,
      builder: (context) => CustomConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        isDestructive: isDestructive,
        showCancelButton: showCancelButton,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.secondaryBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular((16)),
        side: BorderSide(color: AppColors.gold.withOpacity(0.3), width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all((24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null) ...[
              Text(
                title!,
                style: AppTextStyles.font18W700White(context),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: (12)),
            ],
            SizedBox(height: (12)),
            Text(
              message,
              style: AppTextStyles.font16W500Grey(
                context,
              ).copyWith(height: 1.5),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: (24)),
            Row(
              children: [
                if (showCancelButton) ...[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.pop(); // Close dialog
                        if (onCancel != null) onCancel!();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: (12)),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular((8)),
                          border: Border.all(
                            color: AppColors.grey.withOpacity(0.5),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            cancelText,
                            style: AppTextStyles.font14W600White(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: (12)),
                ],
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      context.pop(); // Close dialog
                      onConfirm();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: (12)),
                      decoration: BoxDecoration(
                        color: isDestructive
                            ? Colors.red.withOpacity(0.8)
                            : AppColors.gold,
                        borderRadius: BorderRadius.circular((8)),
                      ),
                      child: Center(
                        child: Text(
                          confirmText,
                          style: isDestructive
                              ? AppTextStyles.font14W600White(context)
                              : AppTextStyles.font12W700Black(context),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
