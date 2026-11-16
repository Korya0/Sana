import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';

class CustomZikrBadge extends StatelessWidget {
  // Creates badge
  const CustomZikrBadge({super.key});

  // Builds badge
  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Tooltip(
      message: AppStrings.customZikr,
      child: ExcludeSemantics(
        child: Container(
          padding: EdgeInsets.all(AppSize.p4),
          decoration: BoxDecoration(
            color: context.color.surfaceBrand,
            shape: BoxShape.circle,
          ),
          child: Icon(
            AppIcons.personAdd,
            size: AppSize.icon16,
            color: context.color.iconOnPrimary,
          ),
        ),
      ),
    ),
  );
}
