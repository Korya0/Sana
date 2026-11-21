import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';

class AddZikrFab extends StatelessWidget {
  const AddZikrFab({
    required this.onPressed,
    super.key,
    this.label,
  });

  final VoidCallback onPressed;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final size = AppSize.h56;

    return AppPressable(
      onPressed: onPressed,
      semanticLabel: AppStrings.addZikr,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null) ...[
            Text(label!, style: AppTextStyles.font14W700Primary(context)),
            AppGap.w(AppSize.p8),
          ],
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: context.color.actionPrimary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                AppIcons.add,
                size: AppSize.icon24,
                color: context.color.iconOnPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
