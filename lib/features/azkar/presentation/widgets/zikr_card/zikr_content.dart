import 'package:flutter/material.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/app_spacing.dart';

class ZikrContent extends StatelessWidget {
  const ZikrContent({
    required this.text,
    super.key,
    this.subText,
  });
  final String text;
  final String? subText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.v32,
      children: [
        Center(
          child: Text(
            text,
            style: AppTextStyles.font20W700(context)
                .copyWith(color: context.color.textPrimary)
                .copyWith(height: 2),
            textAlign: TextAlign.center,
          ),
        ),
        if (subText != null && subText!.isNotEmpty)
          Text(
            subText!,
            style: AppTextStyles.font14W500(context).copyWith(
              color: context.color.textSecondary,
            ),
            textAlign: TextAlign.start,
          ),
      ],
    );
  }
}

class ZikrShareContent extends StatelessWidget {
  const ZikrShareContent({
    required this.text,
    super.key,
    this.subText,
  });
  final String text;
  final String? subText;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.v24,
      children: [
        Center(
          child: Text(
            text,
            style: AppTextStyles.fontQuran26W400White(context).copyWith(
              height: 1.6,
            ),
            textAlign: TextAlign.center,
            maxLines: 10,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (subText != null && subText!.isNotEmpty)
          Text(
            subText!,
            style: AppTextStyles.font16W500(context).copyWith(
              color: context.color.textPrimary.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }
}
