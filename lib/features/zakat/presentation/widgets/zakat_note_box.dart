import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';

class ZakatNoteBox extends StatelessWidget {
  const ZakatNoteBox(this.text, {super.key, this.icon = AppIcons.info});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final accent = context.color.borderBrand;

    return Semantics(
      container: true,
      child: Container(
        padding: EdgeInsets.all(AppSize.p16),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: AppConstants.opacityGhost),
          borderRadius: BorderRadius.circular(AppSize.r16),
          border: Border.all(
            color: accent.withValues(alpha: AppConstants.opacitySoft),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(
              child: Icon(icon, color: context.color.iconBrand),
            ),
            AppGap.w(AppSize.p8),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.font14W400Relaxed(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
