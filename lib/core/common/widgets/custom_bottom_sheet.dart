import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/widgets/app_buttons.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';

class CustomBottomSheet extends StatelessWidget {
  // New generic child

  const CustomBottomSheet({
    super.key,
    this.title,
    this.message,
    this.onPrimaryAction,
    this.onSecondaryAction,
    this.primaryButtonText = 'السماح',
    this.secondaryButtonText,
    this.primaryButtonColor,
    this.secondaryButtonColor,
    this.onWillPop,
    this.child,
  });
  final String? title;
  final String? message;
  final VoidCallback? onPrimaryAction;
  final VoidCallback? onSecondaryAction;
  final String primaryButtonText;
  final String? secondaryButtonText;
  final Color? primaryButtonColor;
  final Color? secondaryButtonColor;
  final Future<bool> Function()? onWillPop;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await (onWillPop?.call() ?? Future.value(true));
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        decoration: const BoxDecoration(
          color: AppColors.secondaryBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              if (title != null) ...[
                Text(title!, style: AppTextStyles.font18W700White(context)),
                const SizedBox(height: 16),
              ],
              if (message != null) ...[
                Text(message!, style: AppTextStyles.font16W500Grey(context)),
                const SizedBox(height: 32),
              ],
              if (child != null) ...[
                // Custom Content
                child!,
                const SizedBox(height: 16),
              ] else if (onPrimaryAction != null) ...[
                Row(
                  children: [
                    if (onSecondaryAction != null &&
                        secondaryButtonText != null) ...[
                      Expanded(
                        child: AppSecondaryButton(
                          text: secondaryButtonText!,
                          onPressed: () {
                            context.pop();
                            onSecondaryAction?.call();
                          },
                          borderColor: secondaryButtonColor,
                          textColor: secondaryButtonColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: AppPrimaryButton(
                        text: primaryButtonText,
                        onPressed: () {
                          context.pop();
                          onPrimaryAction?.call();
                        },
                      ),
                    ),
                  ],
                ),
              ],
              SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> showCustomBottomSheet(
  BuildContext context, {
  String? title,
  String? message,
  VoidCallback? onPrimaryAction,
  VoidCallback? onSecondaryAction,
  String primaryButtonText = 'السماح',
  String? secondaryButtonText,
  Color? primaryButtonColor,
  Color? secondaryButtonColor,
  Future<bool> Function()? onWillPop,
  bool isDismissible = true,
  Widget? child,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isDismissible: isDismissible,
    enableDrag: isDismissible,
    isScrollControlled: true,

    backgroundColor: Colors.transparent,
    builder: (context) => CustomBottomSheet(
      title: title,
      message: message,
      onPrimaryAction: onPrimaryAction,
      onSecondaryAction: onSecondaryAction,
      primaryButtonText: primaryButtonText,
      secondaryButtonText: secondaryButtonText,
      primaryButtonColor: primaryButtonColor,
      secondaryButtonColor: secondaryButtonColor,
      onWillPop: onWillPop,
      child: child,
    ),
  );
}
