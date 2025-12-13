import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';

class ZikrContent extends StatelessWidget {
  final String text;
  final String? subText;

  const ZikrContent({super.key, required this.text, this.subText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: (32),
      children: [
        Center(
          child: Text(
            text,
            style: AppTextStyles.font16W600White(
              context,
            ).copyWith(height: 2, fontSize: (18)),
            textAlign: TextAlign.center,
          ),
        ),
        if (subText != null && subText!.isNotEmpty)
          Text(
            subText!,
            style: AppTextStyles.font14W500Grey(context),
            textAlign: TextAlign.start,
          ),
      ],
    );
  }
}
