import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/features/zakat/data/models/zakat_result.dart';
import 'package:sana/features/zakat/data/utils/number_utils.dart';

class VerdictCard extends StatelessWidget {
  const VerdictCard({super.key, required this.result});

  final ZakatResult result;

  @override
  Widget build(BuildContext context) {
    late final IconData icon;
    late final String title;
    late final Color background;
    late final Color foreground;

    switch (result.status) {
      case ZakatStatus.due:
        icon = AppIcons.checkCircle;
        title = AppStrings.zakatVerdictDue;
        background = context.color.surfaceBrand.withValues(
          alpha: AppConstants.opacityGhost,
        );
        foreground = context.color.textBrand;
      case ZakatStatus.belowNisab:
        icon = AppIcons.info;
        title = AppStrings.zakatVerdictBelowNisab;
        background = context.color.surfaceDisabled.withValues(
          alpha: AppConstants.opacityMuted,
        );
        foreground = context.color.textSecondary;
      case ZakatStatus.hawlNotCompleted:
        icon = AppIcons.hourglass;
        title = AppStrings.zakatVerdictHawlMissing;
        background = context.color.surfaceBrand.withValues(
          alpha: AppConstants.opacityGhost,
        );
        foreground = context.color.textSecondary;
      case ZakatStatus.nisabUnknown:
        icon = AppIcons.help;
        title = AppStrings.zakatVerdictPriceMissing;
        background = context.color.errorText.withValues(
          alpha: AppConstants.opacityGhost,
        );
        foreground = context.color.errorText;
    }

    return Semantics(
      container: true,
      label: title,
      child: Container(
        padding: EdgeInsets.all(AppSize.p20),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppSize.r24),
          border: Border.all(
            color: foreground.withValues(alpha: AppConstants.opacitySoft),
          ),
        ),
        child: Column(
          children: [
            ExcludeSemantics(
              child: Icon(icon, size: AppSize.icon48, color: foreground),
            ),
            AppGap.h(AppSize.p12),
            Semantics(
              header: true,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.font22W700OnColor(context, foreground),
              ),
            ),
            if (result.status == ZakatStatus.due) ...[
              AppGap.h(AppSize.p12),
              Text(
                NumberUtils.formatMoney(
                  result.zakatAmount,
                  currency: result.currency,
                ),
                style: AppTextStyles.font32W700OnColor(context, foreground),
              ),
              AppGap.h(AppSize.p4),
              Text(
                AppStrings.zakatZakatDueAmount,
                style: AppTextStyles.font14W700OnColor(context, foreground),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
