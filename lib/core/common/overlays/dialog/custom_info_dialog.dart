import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sana/core/common/buttons/app_buttons.dart';
import 'package:sana/core/common/overlays/dialog/custom_dialog.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:solar_icons/solar_icons.dart';

Future<void> showCustomInfoDialog({
  required BuildContext context,
  required String title,
  required String warningText,
  required String instructionsTitle,
  required List<String> instructions,
  IconData warningIcon = SolarIconsBold.infoCircle,
  String buttonText = AppStrings.iUnderstood,
}) async {
  await showCustomDialog<void>(
    context: context,
    padding: const EdgeInsets.all(AppSpacing.v20),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Center(
          child: Text(
            title,
            style: AppTextStyles.font18W700White(context),
          ),
        ),

        const SizedBox(height: AppSpacing.v20),

        // Warning Card
        Container(
          padding: const EdgeInsets.all(AppSpacing.v12),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusM),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                warningIcon,
                color: AppColors.iconPrimary,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.v12),
              Expanded(
                child: Text(
                  warningText,
                  style: AppTextStyles.font14W600White(context).copyWith(
                    color: AppColors.textPrimary,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.v20),

        // Instructions
        Text(
          instructionsTitle,
          style: AppTextStyles.font16W700White(context),
        ),

        const SizedBox(height: AppSpacing.v12),

        ...instructions.expand(
          (instruction) => [
            _buildInstructionItem(context, instruction),
            const SizedBox(height: AppSpacing.v8),
          ],
        ),

        const SizedBox(height: AppSpacing.v16),

        // Close Button
        SizedBox(
          width: double.infinity,
          child: AppSecondaryButton(
            text: buttonText,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    ),
  );
}

Widget _buildInstructionItem(BuildContext context, String text) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        margin: const EdgeInsets.only(top: AppSpacing.v4),
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
      ),
      const SizedBox(width: AppSpacing.v12),
      Expanded(
        child: Text(
          text,
          style: AppTextStyles.font14W500White(context).copyWith(
            height: 1.5,
          ),
        ),
      ),
    ],
  );
}
