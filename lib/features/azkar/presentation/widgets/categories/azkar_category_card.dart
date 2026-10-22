import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';

class AzkarCategoryCard extends StatelessWidget {
  const AzkarCategoryCard({
    required this.categoryId,
    required this.title,
    required this.onTap,
    super.key,
  });

  final int categoryId;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Stack(
    alignment: Alignment.topCenter,
    children: [
      // Surface: painted outside the fade, so it stays solid on press.
      SizedBox(
        width: AppSize.w48,
        height: AppSize.h48,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.color.secondaryScaffoldBackgroundColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: context.color.dividerColor,
              width: AppSize.borderWidth,
            ),
          ),
        ),
      ),

      // Content: fades on press. The icon box matches the circle above.
      AppPressable(
        onPressed: onTap,
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
                  _resolveCategoryIcon(categoryId),
                  size: AppSize.icon32,
                  color: context.color.iconPrimary,
                ),
              ),
            ),
            AppGap.h(AppSize.p8),

            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: AppConstants.maxTwoLines,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font12W700Primary(context),
            ),
          ],
        ),
      ),
    ],
  );
}

IconData _resolveCategoryIcon(int categoryId) => switch (categoryId) {
  1 => AppIcons.afterPrayer,
  2 => AppIcons.morning,
  3 => AppIcons.evening,
  4 => AppIcons.sleep,
  5 => AppIcons.wakingUp,
  6 => AppIcons.ablution,
  7 => AppIcons.adhan,
  8 => AppIcons.house,
  9 => AppIcons.mosque,
  10 => AppIcons.restroom,
  11 => AppIcons.foodDrink,
  12 => AppIcons.clothes,
  13 => AppIcons.fasting,
  14 => AppIcons.distress,
  15 => AppIcons.repentance,
  16 => AppIcons.tasbih,
  17 => AppIcons.marriage,
  18 => AppIcons.children,
  19 => AppIcons.sickness,
  20 => AppIcons.death,
  21 => AppIcons.funeral,
  22 => AppIcons.travel,
  23 => AppIcons.openingSupplication,
  _ => AppIcons.adhkar,
};
