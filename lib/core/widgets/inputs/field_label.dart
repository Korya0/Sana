import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/widgets/app_gap.dart';

class FieldLabel extends StatelessWidget {
  const FieldLabel({
    required this.label,
    super.key,
    this.isRequired = false,
    this.isOptional = false,
  });

  final String label;
  final bool isRequired;
  final bool isOptional;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      // Label
      Flexible(
        child: Text(
          label,
          maxLines: AppConstants.maxOneLine,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.font14W700Primary(context),
        ),
      ),
      if (isRequired) ...[
        AppGap.w(AppSize.p4),
        // Required mark
        Text(
          AppStrings.requiredFieldMark,
          semanticsLabel: AppStrings.requiredField,
          style: AppTextStyles.font14W700Error(context),
        ),
      ],
      if (isOptional) ...[
        AppGap.w(AppSize.p4),
        // Optional hint
        Text(
          AppStrings.optionalFieldMark,
          style: AppTextStyles.font12W500Secondary(context),
        ),
      ],
    ],
  );
}
