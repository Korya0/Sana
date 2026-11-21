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
  Widget build(BuildContext context) {
    // Required wins when both flags are set; never show both marks.
    final showRequired = isRequired;
    final showOptional = isOptional && !isRequired;

    return Row(
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
        if (showRequired) ...[
          AppGap.w(AppSize.p4),
          // Required mark
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: AppSize.w48),
            child: Text(
              AppStrings.requiredFieldMark,
              semanticsLabel: AppStrings.requiredField,
              maxLines: AppConstants.maxOneLine,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font14W700Error(context),
            ),
          ),
        ],
        if (showOptional) ...[
          AppGap.w(AppSize.p4),
          // Optional hint
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: AppSize.w48),
            child: Text(
              AppStrings.optionalFieldMark,
              maxLines: AppConstants.maxOneLine,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font12W500Secondary(context),
            ),
          ),
        ],
      ],
    );
  }
}
