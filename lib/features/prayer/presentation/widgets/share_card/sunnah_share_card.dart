import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/services/sharing/presentation/app_info_share.dart';
import 'package:sana/core/services/sharing/presentation/share_card_container.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';

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
        decoration: const BoxDecoration(
          color: AppColors.secondaryBackground,
          borderRadius: BorderRadius.zero,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header (Centered for Share Card)
            Center(
              child: Text(
                prayerName,
                style: AppTextStyles.font18W700primary(context),
              ),
            ),
            const SizedBox(height: AppSpacing.v16),
            Divider(color: AppColors.grey.withValues(alpha: 0.2), height: 1),
            const SizedBox(height: AppSpacing.v16),

            // Title
            Text(
              prayerName == 'العصر'
                  ? AppStrings.nobleHadith
                  : AppStrings.confirmedSunnah,
              style: AppTextStyles.font16W700primary(context),
            ),
            const SizedBox(height: AppSpacing.v12),

            // Content Card (The Main Hadith Box)
            Container(
              padding: const EdgeInsets.all(AppSpacing.v16),
              decoration: BoxDecoration(
                color: AppColors.secondaryBackground.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    hadithText,
                    style: AppTextStyles.font14W400Grey(
                      context,
                    ).copyWith(height: 1.6),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.v12),
                  Divider(
                    color: AppColors.grey.withValues(alpha: 0.2),
                    height: 1,
                  ),
                  const SizedBox(height: AppSpacing.v8),
                  Text(
                    narrator,
                    style: AppTextStyles.font12W500Grey(context),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.v40),
            // Brand footer - App Info Only
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
