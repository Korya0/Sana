import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';

class OptionTile extends StatelessWidget {
  const OptionTile({
    required this.icon,
    required this.label,
    required this.onPressed,
    super.key,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) => AppPressable(
    onPressed: onPressed,
    disabledOpacity: AppConstants.opacityDisabled,
    child: SizedBox(
      height: AppSize.h56,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSize.p12),
        child: Row(
          children: [
            // Icon
            Icon(
              icon,
              size: AppSize.icon24,
              color: isDestructive
                  ? context.color.errorText
                  : context.color.iconNeutral,
            ),
            AppGap.w(AppSize.p12),

            // Label
            Expanded(
              child: Text(
                label,
                maxLines: AppConstants.maxOneLine,
                overflow: TextOverflow.ellipsis,
                style: isDestructive
                    ? AppTextStyles.font14W700Error(context)
                    : AppTextStyles.font14W700Primary(context),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
