import 'package:flutter/material.dart';
import 'package:sana/core/utils/context_extension.dart';

import 'package:sana/core/common/overlays/bottom_sheet/show_custom_bottom_sheet.dart';
import 'package:sana/core/theme/fonts/app_fonts_family.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/features/prayer/data/models/prayer_type.dart';
import 'package:sana/features/prayer/presentation/widgets/prayer_sunnah_bottom_sheet.dart';

class PrayerCardContent extends StatelessWidget {
  const PrayerCardContent({
    required this.type,
    required this.name,
    required this.time,
    required this.isNext,
    super.key,
    this.isLast = false,
  });

  final PrayerType type;
  final String name;
  final String time;
  final bool isNext;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await showCustomBottomSheet(
          context,
          child: PrayerSunnahBottomSheet(
            prayerType: type,
            prayerName: name,
            prayerTime: time.replaceAll('\n', ' '),
          ),
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
          color: isNext
              ? context.color.primary.withValues(alpha: 0.15)
              : context.color.secondaryScaffoldBackgroundColor.withValues(alpha: 0.2),
          border: Border.all(
            color: isNext
                ? context.color.primary.withValues(alpha: 0.4)
                : context.color.primary.withValues(alpha: 0.08),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: AppTextStyles.font12W700white(context).copyWith(
                color: isNext ? context.color.primary : context.color.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.v2),
            Text(
              time.replaceAll('\n', ' '),
              style: AppTextStyles.font10W500Grey(context).copyWith(
                color: isNext
                    ? context.color.primary.withValues(alpha: 0.9)
                    : Colors.white.withValues(alpha: 0.6),
                fontWeight: isNext ? CairoFontWeight.w700 : CairoFontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

