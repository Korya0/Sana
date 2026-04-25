import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/buttons/app_buttons.dart';
import 'package:sana/core/common/overlays/dialog/custom_dialog.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:solar_icons/solar_icons.dart';

class DailyContentExplanationDialog extends StatelessWidget {
  const DailyContentExplanationDialog({
    required this.explanation,
    super.key,
  });

  final String explanation;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      useGlassmorphism: true,
      borderRadius: 28,
      borderColor: AppColors.primary.withValues(alpha: 0.2),
      borderWidth: 1.5,
      padding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.v20,
        vertical: AppSpacing.v40,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.v20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.explanationAndClarification,
                  style: AppTextStyles.font16W600primary(context),
                ),
                Row(
                  children: [
                    // Copy Only Button
                    IconButton(
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(text: explanation),
                        );
                      },
                      icon: const Icon(
                        SolarIconsOutline.copy,
                        color: AppColors.iconPrimary,
                        size: 20,
                      ),
                      tooltip: AppStrings.copyExplanation,
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        SolarIconsOutline.closeCircle,
                        color: AppColors.iconWhite.withValues(alpha: 0.54),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 10, color: AppColors.primary),

          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.v24),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  explanation,
                  style: AppTextStyles.font16W500Grey(context).copyWith(
                    height: 1.6,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ),

          // Footer Action
          Padding(
            padding: const EdgeInsets.all(AppSpacing.v20),
            child: AppPrimaryButton(
              onPressed: () => context.pop(),
              text: AppStrings.understoodJazakAllahuKhairan,
            ),
          ),
        ],
      ),
    );
  }

  static void show(
    BuildContext context, {
    required String explanation,
  }) {
    unawaited(
      showDialog<void>(
        context: context,
        barrierColor: Colors.transparent,
        builder: (context) => DailyContentExplanationDialog(
          explanation: explanation,
        ),
      ),
    );
  }
}
