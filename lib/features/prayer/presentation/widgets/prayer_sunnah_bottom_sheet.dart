import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/common/decorations/custom_app_divider.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/features/sharing/logic/widget_to_image.dart';
import 'package:sana/features/sharing/presentation/combined_share_copy_button.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/features/prayer/data/models/sunnah_model.dart';
import 'package:sana/features/prayer/presentation/widgets/share_card/sunnah_share_card.dart';

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
        const SizedBox(height: AppSpacing.v16),
        if (sunnah != null) ...[
          const CustomAppDivider(),
          const SizedBox(height: AppSpacing.v16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                prayerName == 'العصر'
                    ? AppStrings.nobleHadith
                    : AppStrings.confirmedSunnah,
                style: AppTextStyles.font16W700Gold(context),
              ),
              CombinedShareCopyButton(
                onSharePressed: () async {
                  await WidgetToImage.shareWidget(
                    context: context,
                    widget: SunnahShareCard(
                      prayerName: prayerName,
                      hadithText: sunnah.hadith.text,
                      narrator: sunnah.hadith.narrator,
                      rakats: sunnah.rakats,
                      timing: sunnah.timing,
                    ),
                    imageName: 'prayer_sunnah_${prayerName}_share',
                  );
                },
                onCopyPressed: () async {
                  final textToCopy =
                      '${sunnah.hadith.text}\n\n${sunnah.hadith.narrator}';
                  await Clipboard.setData(ClipboardData(text: textToCopy));
                },
                iconSize: 20,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.v12),
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
                  sunnah.hadith.text,
                  style: AppTextStyles.font14W400WhiteHeight16(
                    context,
                  ).copyWith(fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.v12),
                const CustomAppDivider(),
                const SizedBox(height: AppSpacing.v8),
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
              padding: const EdgeInsets.all(AppSpacing.v24),
              child: Text(
                AppStrings.noSunnahForPrayer,
                style: AppTextStyles.font14W500Grey(context),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
