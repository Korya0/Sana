import 'package:flutter/material.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_spacing.dart';

class ZikrContent extends StatelessWidget {
  const ZikrContent({
    required this.text,
    super.key,
    this.subText,
    this.isSharing = false,
  });
  final String text;
  final String? subText;
  final bool isSharing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isSharing ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      spacing: isSharing ? AppSpacing.v24 : AppSpacing.v32,
      children: [
        Center(
          child: Text(
            text,
            style: isSharing
                ? AppTextStyles.fontQuran26W400White(context).copyWith(
                    height: 1.6,
                  )
                : AppTextStyles.font20W700(context).copyWith(color: context.color.textPrimary).copyWith(
                    height: 2,
                  ),
            textAlign: TextAlign.center,
            maxLines: isSharing ? 10 : null,
            overflow: isSharing ? TextOverflow.ellipsis : null,
          ),
        ),
        if (subText != null && subText!.isNotEmpty)
          Text(
            subText!,
            style: isSharing
                ? AppTextStyles.font16W500(context).copyWith(color: context.color.textPrimary.withValues(alpha: 0.7))
                : AppTextStyles.font14W500(context).copyWith(color: context.color.textSecondary),
            textAlign: isSharing ? TextAlign.center : TextAlign.start,
            maxLines: isSharing ? 2 : null,
            overflow: isSharing ? TextOverflow.ellipsis : null,
          ),
      ],
    );
  }
}

