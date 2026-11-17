import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';

class OptionTile extends StatelessWidget {
  // Creates tile
  const OptionTile({
    required this.icon,
    required this.label,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  // Builds tile
  @override
  Widget build(BuildContext context) => AppPressable(
    onPressed: onPressed,
    disabledOpacity: AppConstants.opacityDisabled,
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.p12,
        vertical: AppSize.p12,
      ),
      child: Row(
        children: [
          // Icon
          Icon(
            icon,
            size: AppSize.icon24,
            color: context.color.iconPrimary,
          ),
          AppGap.w(AppSize.p12),

          // Label
          Expanded(
            child: Text(
              label,
              maxLines: AppConstants.maxOneLine,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font14W700Primary(context),
            ),
          ),
          AppGap.w(AppSize.p8),

          // Arrow
          Icon(
            AppIcons.arrowForward,
            size: AppSize.icon16,
            color: context.color.iconSecondary,
          ),
        ],
      ),
    ),
  );
}
