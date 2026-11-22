import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_button.dart';

class CalculateActionButtons extends StatelessWidget {
  const CalculateActionButtons({
    super.key,
    required this.isFirstStage,
    required this.isFinalStage,
    required this.canSubmit,
    required this.onNext,
    required this.onPrevious,
    required this.onSubmit,
  });

  final bool isFirstStage;
  final bool isFinalStage;
  final bool canSubmit;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final primaryEnabled = !isFinalStage || canSubmit;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSize.p16,
        AppSize.p12,
        AppSize.p16,
        AppSize.p16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (!isFirstStage) ...[
                Expanded(
                  child: AppButton(
                    label: AppStrings.zakatPrevious,
                    icon: AppIcons.back,
                    onPressed: onPrevious,
                    variant: AppButtonVariant.secondary,
                    expand: true,
                  ),
                ),
                AppGap.w(AppSize.p12),
              ],
              Expanded(
                child: AppButton(
                  label: isFinalStage
                      ? AppStrings.zakatCalculateAction
                      : AppStrings.zakatNext,
                  icon: isFinalStage
                      ? AppIcons.calculate
                      : AppIcons.arrowForward,
                  onPressed: primaryEnabled
                      ? (isFinalStage ? onSubmit : onNext)
                      : null,
                  expand: true,
                ),
              ),
            ],
          ),
          if (isFinalStage && !canSubmit) ...[
            AppGap.h(AppSize.p8),
            Semantics(
              liveRegion: true,
              child: Text(
                AppStrings.zakatHawlError,
                textAlign: TextAlign.center,
                style: AppTextStyles.font12W500Error(context),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
