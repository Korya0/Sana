import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/prayer/data/models/sunnah_model.dart';

class PrayerSunnahBottomSheet extends StatelessWidget {
  const PrayerSunnahBottomSheet({
    required this.prayerName,
    required this.prayerTime,
    super.key,
  });
  final String prayerName;
  final String prayerTime;

  @override
  Widget build(BuildContext context) {
    final sunnah = SunnahData.prayers[prayerName];
    return _buildContent(context, sunnah);
  }

  Widget _buildContent(BuildContext context, PrayerSunnah? sunnah) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(prayerName, style: AppTextStyles.font18W700Gold(context)),
            Text(prayerTime, style: AppTextStyles.font18W500White(context)),
          ],
        ),
        const SizedBox(height: 16),
        if (sunnah != null) ...[
          Divider(color: AppColors.grey.withValues(alpha: 0.2), height: 1),
          const SizedBox(height: 16),
          Text('السنن المؤكدة', style: AppTextStyles.font16W700Gold(context)),
          const SizedBox(height: 16),
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
                  sunnah.hadith.text,
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
                  sunnah.hadith.narrator,
                  style: AppTextStyles.font12W500Grey(context),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ] else ...[
          // Fallback
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'لا توجد سنن مؤكدة لهذه الصلاة',
                style: AppTextStyles.font14W500Grey(context),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
