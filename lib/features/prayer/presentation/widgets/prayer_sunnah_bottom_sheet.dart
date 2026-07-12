import 'package:flutter/material.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/services/sharing/presentation/utils/app_share.dart';
import 'package:sana/core/services/sharing/presentation/combined_share_copy_button.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/features/prayer/domain/entities/prayer_type.dart';
import 'package:sana/features/prayer/domain/entities/sunnah_entity.dart';
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
        if (sunnah != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                prayerType == PrayerType.asr
                    ? AppStrings.nobleHadith
                    : AppStrings.confirmedSunnah,
                style: AppTextStyles.font16W700(
                  context,
                ).copyWith(color: context.color.textAccent),
              ),
              CombinedShareCopyButton(
                onSharePressed: () async {
                  await AppShare.shareWidgetAsImage(
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
                iconSize: AppSpacing.s20.r(context),
              ),
            ],
          ),
          const AppGap.h(AppSpacing.v16),
          const CustomAppDivider(),
          const AppGap.h(AppSpacing.v16),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              prayerName,
              style: AppTextStyles.font20W700(
                context,
              ).copyWith(color: context.color.textAccent),
            ),
            Text(
              prayerTime,
              style: AppTextStyles.font16W500(
                context,
              ).copyWith(color: context.color.textPrimary),
            ),
          ],
        ),
        if (sunnah != null) ...[
          const AppGap.h(AppSpacing.v12),
          Container(
            padding: const EdgeInsets.all(AppSpacing.v16),
            decoration: BoxDecoration(
              color: context.color.secondaryScaffoldBackgroundColor.withValues(
                alpha: 0.5,
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusM),
              border: Border.all(color: context.color.textPrimary.withValues(alpha: 0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  sunnah.hadith.text,
                  style: AppTextStyles.font14W500(
                    context,
                  ).copyWith(color: context.color.textPrimary, height: 1.6),
                  textAlign: TextAlign.center,
                ),
                const AppGap.h(AppSpacing.v12),
                const CustomAppDivider(),
                const AppGap.h(AppSpacing.v8),
                Text(
                  sunnah.hadith.narrator,
                  style: AppTextStyles.font14W500(
                    context,
                  ).copyWith(color: context.color.textPrimary),
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
                style: AppTextStyles.font14W500(
                  context,
                ).copyWith(color: context.color.textSecondary),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
