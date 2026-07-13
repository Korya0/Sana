import 'package:sana/core/common/common.dart';
import 'package:flutter/material.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/features/sharing/presentation/app_info_share.dart';
import 'package:sana/features/sharing/presentation/share_card_container.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/app_spacing.dart';

class SunnahShareCard extends StatelessWidget {
  const SunnahShareCard({
    required this.prayerName,
    required this.hadithText,
    required this.narrator,
    this.rakats,
    this.timing,
    super.key,
  });

  final String prayerName;
  final String hadithText;
  final String narrator;
  final String? rakats;
  final String? timing;

  @override
  Widget build(BuildContext context) {
    return ShareCardContainer(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.v24),
        decoration: BoxDecoration(
          color: context.color.secondaryScaffoldBackgroundColor,
          borderRadius: BorderRadius.zero,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              prayerName == 'العصر'
                  ? AppStrings.nobleHadith
                  : AppStrings.confirmedSunnah,
              style: AppTextStyles.font16W700(
                context,
              ).copyWith(color: context.color.textAccent),
            ),
            const AppGap.h(AppSpacing.v16),
            Divider(
              color: context.color.textSecondary.withValues(alpha: 0.2),
              height: 1,
            ),
            const AppGap.h(AppSpacing.v16),
            Center(
              child: Text(
                prayerName,
                style: AppTextStyles.font20W700(
                  context,
                ).copyWith(color: context.color.textAccent),
              ),
            ),
            const AppGap.h(AppSpacing.v12),

            Container(
              padding: const EdgeInsets.all(AppSpacing.v16),
              decoration: BoxDecoration(
                color: context.color.secondaryScaffoldBackgroundColor
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                border: Border.all(color: context.color.textPrimary.withValues(alpha: 0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    hadithText,
                    style: AppTextStyles.font14W500(
                      context,
                    ).copyWith(color: context.color.textSecondary, height: 1.6),
                    textAlign: TextAlign.center,
                  ),
                  const AppGap.h(AppSpacing.v12),
                  Divider(
                    color: context.color.textSecondary.withValues(alpha: 0.2),
                    height: 1,
                  ),
                  const AppGap.h(AppSpacing.v8),
                  Text(
                    narrator,
                    style: AppTextStyles.font12W500(
                      context,
                    ).copyWith(color: context.color.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const AppGap.h(AppSpacing.v40),
            AppInfoShare(
              department:
                  '${AppConstants.appName} - ${prayerName == 'العصر' ? AppStrings.nobleHadith : AppStrings.confirmedSunnah}',
            ),
          ],
        ),
      ),
    );
  }
}
