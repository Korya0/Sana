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

  @override
  Widget build(BuildContext context) => Stack(
    alignment: Alignment.topCenter,
    children: [
      // Surface
      Container(
        width: AppSize.w52,
        height: AppSize.h52,
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

      // Content
      AppPressable(
        onPressed: onTap,
        onLongPress: onLongPress,
        semanticLabel: title,
        excludeChildSemantics: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: AppSize.w52,
              height: AppSize.h52,
              child: Center(
                child: Icon(
                  type?.icon ?? AppIcons.adhkar,
                  size: AppSize.icon24,
                  color: context.color.iconPrimary,
                ),
              ),
            ),
            AppGap.h(AppSize.p8),
            // Title
            AppMarqueeText(
              text: title,
              style: AppTextStyles.font12W700Primary(context),
            ),
          ],
        ),
      ),
    ],
  );
}
