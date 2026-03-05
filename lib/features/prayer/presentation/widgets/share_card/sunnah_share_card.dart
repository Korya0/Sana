import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/sharing/presentation/app_info_share.dart';
import 'package:sana/core/sharing/presentation/share_card_container.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';

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
        padding: const EdgeInsets.all(24),
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
                style: AppTextStyles.font18W700Gold(context),
              ),
            ),
            const SizedBox(height: 16),
            Divider(color: AppColors.grey.withValues(alpha: 0.2), height: 1),
            const SizedBox(height: 16),

            // Title
            Text(
              prayerName == 'العصر'
                  ? AppStrings.nobleHadith
                  : AppStrings.confirmedSunnah,
              style: AppTextStyles.font16W700Gold(context),
            ),
            const SizedBox(height: 12),

            // Content Card (The Main Hadith Box)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.secondaryBackground.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    hadithText,
                    style: AppTextStyles.font14W400WhiteHeight16(
                      context,
                    ).copyWith(fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Divider(
                    color: AppColors.grey.withValues(alpha: 0.2),
                    height: 1,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    narrator,
                    style: AppTextStyles.font12W500Grey(context),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
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
