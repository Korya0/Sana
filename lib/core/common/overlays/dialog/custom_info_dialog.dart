import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/buttons/app_buttons.dart';
import 'package:sana/core/common/overlays/dialog/custom_dialog.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';
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
    child: Builder(
      builder: (innerContext) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        // Title
        Center(
          child: Text(
            title,
            style: AppTextStyles.font20W700(innerContext).copyWith(color: innerContext.color.textPrimary),
          ),
        ),

        const SizedBox(height: AppSpacing.v20),

        // Warning Card
        Container(
          padding: const EdgeInsets.all(AppSpacing.v12),
          decoration: BoxDecoration(
            color: innerContext.color.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusM),
            border: Border.all(
              color: innerContext.color.primary.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                warningIcon,
                color: innerContext.color.primary,
                size: 20.r(innerContext),
              ),
              const SizedBox(width: AppSpacing.v12),
              Expanded(
                child: Text(
                  warningText,
                  style: AppTextStyles.font14W700(innerContext).copyWith(color: innerContext.color.textPrimary).copyWith(
                    color: innerContext.color.textAccent,
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
          style: AppTextStyles.font16W700(innerContext).copyWith(color: innerContext.color.textPrimary),
        ),

        const SizedBox(height: AppSpacing.v12),

        ...instructions.expand(
          (instruction) => [
            _InstructionItem(text: instruction),
            const SizedBox(height: AppSpacing.v8),
          ],
        ),

        const SizedBox(height: AppSpacing.v16),

        // Close Button
        SizedBox(
          width: double.infinity,
          child: AppSecondaryButton(
            text: buttonText,
            onPressed: () {
              unawaited(playVibrate());
              innerContext.pop();
            },
          ),
        ),
      ],
    ),
    ),
  );
}

class _InstructionItem extends StatelessWidget {
  const _InstructionItem({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: AppSpacing.v4),
          width: AppSpacing.v6.r(context),
          height: AppSpacing.v6.r(context),
          decoration: BoxDecoration(
            color: context.color.primary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppSpacing.v12),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.font14W500(context).copyWith(color: context.color.textPrimary).copyWith(
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

