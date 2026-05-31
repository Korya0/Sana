import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/common/decorations/custom_app_divider.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/services/sharing/presentation/utils/widget_to_image_helper.dart';
import 'package:sana/core/services/sharing/presentation/combined_share_copy_button.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/features/prayer/data/models/prayer_type.dart';
import 'package:sana/features/prayer/data/models/sunnah_model.dart';
import 'package:sana/features/prayer/presentation/widgets/share_card/sunnah_share_card.dart';

class PrayerSunnahBottomSheet extends StatelessWidget {
  const PrayerSunnahBottomSheet({
    required this.prayerType,
    required this.prayerName,
    required this.prayerTime,
    super.key,
  });

  final PrayerType prayerType;
  final String prayerName;
  final String prayerTime;

  @override
  Widget build(BuildContext context) {
    final sunnah = SunnahData.prayers[prayerType];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(prayerName, style: AppTextStyles.font18W700primary(context)),
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
                prayerType == PrayerType.asr
                    ? AppStrings.nobleHadith
                    : AppStrings.confirmedSunnah,
                style: AppTextStyles.font16W700primary(context),
              ),
              CombinedShareCopyButton(
                onSharePressed: () async {
                  await WidgetToImageHelper.shareWidget(
                    context: context,
                    widget: SunnahShareCard(
                      prayerName: prayerName,
                      hadithText: sunnah.hadith.text,
                      narrator: sunnah.hadith.narrator,
                      rakats: sunnah.rakats,
                      timing: sunnah.timing,
                    ),
                    imageName: 'prayer_sunnah_${prayerType.name}_share',
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
                  style: AppTextStyles.font14W400White(
                    context,
                  ).copyWith(height: 1.6),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.v12),
                const CustomAppDivider(),
                const SizedBox(height: AppSpacing.v8),
                Text(
                  sunnah.hadith.narrator,
                  style: AppTextStyles.font14W400White(context),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ] else ...[
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
