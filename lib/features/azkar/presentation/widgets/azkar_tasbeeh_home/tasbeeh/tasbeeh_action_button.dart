import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';

class TasbeehActionButton extends StatelessWidget {
  const TasbeehActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    super.key,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => AppPressable(
    onPressed: onPressed,
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: AppSize.p8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: AppSize.icon16,
            color: context.color.iconBrand,
          ),
          AppGap.w(AppSize.p4),
          Flexible(
            child: Text(
              label,
              maxLines: AppConstants.maxOneLine,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font12W700Brand(context),
            ),
          ),
        ],
      ),
    ),
  );
}
