/// [CustomConfirmationDialog]
/// - الوظيفة الأساسية: نافذة لتأكيد أو إلغاء إجراء معين مع عرض رسالة. يحتوي على زرين (تأكيد / إلغاء) ويمكن جعله "Destructive" (لحذف شيء فتظهر باللون الأحمر).
/// - الاستخدام:
///   * أذكار: تنبيه الخروج وعدم اكتمال الورد (azkar_list_view).
///   * الإدارة: تأكيد حذف الاقتراحات (admin_feedback_actions).
///   * الصلاة على النبي: تأكيد حفظ التغييرات عند الخروج (salat_ala_nabi_view).
///   * التحديث: عند مطالبتك بتحديث التطبيق إجبارياً أو اختيارياً.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/buttons/app_buttons.dart';
import 'package:sana/core/common/overlays/dialog/custom_dialog.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';

class CustomConfirmationDialog extends StatelessWidget {
  const CustomConfirmationDialog({
    required this.confirmText,
    required this.onConfirm,
    this.message,
    this.content,
    super.key,
    this.title,
    this.cancelText = 'إلغاء',
    this.onCancel,
    this.isDestructive = false,
    this.showCancelButton = true,
  }) : assert(
         message != null || content != null,
         'Either message or content must be provided',
       );

  final String? title;
  final String? message;
  final Widget? content;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;
  final bool showCancelButton;

  static Future<void> show(
    BuildContext context, {
    required String confirmText,
    required VoidCallback onConfirm,
    String? title,
    String? message,
    Widget? content,
    String cancelText = 'إلغاء',
    VoidCallback? onCancel,
    bool isDestructive = false,
    bool showCancelButton = true,
  }) {
    return showCustomDialog<void>(
      context: context,
      borderColor: AppColors.gold.withValues(alpha: 0.3),
      child: CustomConfirmationDialog(
        title: title,
        message: message,
        content: content,
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
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: AppTextStyles.font18W700White(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
          ],
          if (content != null) ...[
            content!,
            const SizedBox(height: 24),
          ] else if (message != null) ...[
            Text(
              message!,
              style: AppTextStyles.font16W500Grey(
                context,
              ).copyWith(height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
          ],
          Row(
            children: [
              if (showCancelButton) ...[
                Expanded(
                  child: AppSecondaryButton(
                    text: cancelText,
                    onPressed: () {
                      context.pop();
                      if (onCancel != null) onCancel?.call();
                    },
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: AppPrimaryButton(
                  text: confirmText,
                  onPressed: () {
                    context.pop();
                    onConfirm();
                  },
                  backgroundColor: isDestructive
                      ? Colors.red.withValues(alpha: 0.8)
                      : AppColors.gold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
