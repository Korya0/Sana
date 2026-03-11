import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/buttons/app_buttons.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/common/overlays/dialog/custom_dialog.dart';
import 'package:solar_icons/solar_icons.dart';

Future<void> showSalawatHelpDialog(BuildContext context) async {
  await showCustomDialog<void>(
    context: context,
    padding: const EdgeInsets.all(20),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Center(
          child: Text(
            AppStrings.importantNotes,
            style: AppTextStyles.font18W700White(context),
          ),
        ),

        const SizedBox(height: 20),

        // Warning Card
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.gold.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                SolarIconsBold.infoCircle,
                color: AppColors.gold,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppStrings.reminderDelayWarning,
                  style: AppTextStyles.font14W600White(
                    context,
                  ).copyWith(color: AppColors.gold, height: 1.5),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Instructions
        Text(
          AppStrings.ensureServiceContinuity,
          style: AppTextStyles.font16W700White(context),
        ),

        const SizedBox(height: 12),

        _buildInstructionItem(context, AppStrings.openAppDaily),

        const SizedBox(height: 8),

        _buildInstructionItem(
          context,
          AppStrings.reactivateServiceOccasionally,
        ),

        const SizedBox(height: 8),

        _buildInstructionItem(
          context,
          AppStrings.checkAppSettings,
        ),

        const SizedBox(height: 24),

        // Close Button
        SizedBox(
          width: double.infinity,
          child: AppSecondaryButton(
            text: AppStrings.iUnderstood,
            onPressed: () => context.pop(),
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
        margin: const EdgeInsets.only(top: 4),
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          color: AppColors.green,
          shape: BoxShape.circle,
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Text(
          text,
          style: AppTextStyles.font14W500Grey(
            context,
          ).copyWith(color: AppColors.textWhite.withAlpha(200), height: 1.5),
        ),
      ),
    ],
  );
}
