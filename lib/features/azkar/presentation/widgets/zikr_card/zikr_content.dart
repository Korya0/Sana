import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/widgets/app_gap.dart';

class ZikrContent extends StatelessWidget {
  const ZikrContent({
    required this.text,
    required this.fontSize,
    super.key,
    this.subText,
  });

  final String text;
  final String? subText;
  final double fontSize;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      // Zikr text
      Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyles.fontZikrW700Primary(context, fontSize),
      ),
      if (subText != null && subText!.isNotEmpty) ...[
        AppGap.h(AppSize.p32),

        // Description
        Text(
          subText!,
          textAlign: TextAlign.start,
          style: AppTextStyles.font14W500Secondary(context),
        ),
      ],
    ],
  );
}
