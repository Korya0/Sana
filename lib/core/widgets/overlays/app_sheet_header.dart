import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_icon_button.dart';
import 'package:sana/core/widgets/buttons/app_text_button.dart';

class AppSheetHeader extends StatelessWidget {
  const AppSheetHeader({
    required this.title,
    required this.onDismiss,
    super.key,
    this.isNested = false,
    this.onSave,
    this.isSaveEnabled = true,
    this.isSaving = false,
  });

  final String title;
  final VoidCallback onDismiss;
  final bool isNested;
  final VoidCallback? onSave;
  final bool isSaveEnabled;
  final bool isSaving;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      // Dismiss (close or back)
      AppIconButton(
        icon: isNested ? AppIcons.back : AppIcons.close,
        tooltip: isNested ? AppStrings.back : AppStrings.close,
        onPressed: onDismiss,
      ),
      AppGap.w(AppSize.p4),

      // Title
      Expanded(
        child: Text(
          title,
          maxLines: AppConstants.maxOneLine,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
          style: AppTextStyles.font16W700Primary(context),
        ),
      ),

      // Save
      if (onSave != null)
        AppTextButton(
          label: AppStrings.save,
          onPressed: isSaving || !isSaveEnabled ? null : onSave,
        ),
    ],
  );
}
