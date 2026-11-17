import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';
import 'package:sana/core/widgets/text/app_marquee_text.dart';
import 'package:sana/features/azkar/domain/enums/azkar_category_type.dart';
import 'package:sana/features/azkar/presentation/extensions/azkar_category_type_icon.dart';

class AzkarCategoryCard extends StatelessWidget {
  // Creates card
  const AzkarCategoryCard({
    required this.title,
    required this.onTap,
    super.key,
    this.type,
    this.onLongPress,
  });

  final AzkarCategoryType? type;
  final String title;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  // Builds card
  @override
  Widget build(BuildContext context) => Stack(
    alignment: Alignment.topCenter,
    children: [
      // Surface
      SizedBox(
        width: AppSize.w48,
        height: AppSize.h48,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.color.secondaryScaffoldBackgroundColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: context.color.borderBrand.withValues(
                alpha: AppConstants.opacitySubtle,
              ),
              width: AppSize.borderWidth,
            ),
          ),
        ),
      ),

      // Content (icon + title)
      AppPressable(
        onPressed: onTap,
        onLongPress: onLongPress,
        semanticLabel: title,
        excludeChildSemantics: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            SizedBox(
              width: AppSize.w48,
              height: AppSize.h48,
              child: Center(
                child: Icon(
                  type?.icon ?? AppIcons.adhkar,
                  size: AppSize.icon32,
                  color: context.color.iconPrimary,
                ),
              ),
            ),
            AppGap.h(AppSize.p8),

            // Title
            Flexible(
              child: AppMarqueeText(
                text: title,
                style: AppTextStyles.font11W700Primary(context),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
