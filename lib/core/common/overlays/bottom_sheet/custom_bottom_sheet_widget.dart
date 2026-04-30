import 'package:flutter/material.dart';
import 'package:sana/core/common/buttons/app_buttons.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/core/utils/context_extension.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({
    super.key,
    this.title,
    this.message,
    this.onPrimaryAction,
    this.onSecondaryAction,
    this.primaryButtonText = AppStrings.confirm,
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
          left: AppSpacing.v24,
          right: AppSpacing.v24,
          top: AppSpacing.v24,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.v24,
        ),
        decoration: const BoxDecoration(
          color: AppColors.secondaryBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppSpacing.radiusL),
            topRight: Radius.circular(AppSpacing.radiusL),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.v24),
                  width: AppSpacing.v48.r(context),
                  height: AppSpacing.v6.r(context),
                  decoration: BoxDecoration(
                    color: AppColors.grey,
                    borderRadius: BorderRadius.circular(AppSpacing.v4),
                  ),
                ),
              ),
              if (title != null) ...[
                Text(title!, style: AppTextStyles.font18W700White(context)),
                const SizedBox(height: AppSpacing.v16),
              ],
              if (message != null) ...[
                Text(message!, style: AppTextStyles.font16W500Grey(context)),
                const SizedBox(height: AppSpacing.v32),
              ],
              if (child != null) ...[
                child!,
                const SizedBox(height: AppSpacing.v16),
              ],
              if (onPrimaryAction != null) ...[
                Row(
                  children: [
                    if (onSecondaryAction != null &&
                        secondaryButtonText != null) ...[
                      Expanded(
                        child: AppSecondaryButton(
                          text: secondaryButtonText!,
                          onPressed: () {
                            Navigator.of(context).pop();
                            onSecondaryAction?.call();
                          },
                          borderColor: secondaryButtonColor,
                          textColor: secondaryButtonColor,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.v12),
                    ],
                    Expanded(
                      child: AppPrimaryButton(
                        text: primaryButtonText,
                        onPressed: () {
                          Navigator.of(context).pop();
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
