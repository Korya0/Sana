import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';

class TasbeehChip extends StatelessWidget {
  const TasbeehChip({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => AppPressable(
    onPressed: onPressed,
    child: Container(
      height: AppSize.h40,
      padding: EdgeInsets.symmetric(horizontal: AppSize.p8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.r12),
        border: Border.all(
          color: context.color.dividerColor,
          width: AppSize.borderWidth,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              label,
              maxLines: AppConstants.maxOneLine,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font12W700Brand(context),
            ),
          ),
          if (icon != null) ...[
            AppGap.w(AppSize.p4),
            Icon(icon, size: AppSize.icon16, color: context.color.iconBrand),
          ],
        ],
      ),
    ),
  );
}
