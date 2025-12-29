import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';

class ZikrContent extends StatelessWidget {
  final String text;
  final String? subText;
  final bool isSharing;

  const ZikrContent({
    super.key,
    required this.text,
    this.subText,
    this.isSharing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isSharing
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      spacing: isSharing ? 24 : 32,
      children: [
        Center(
          child: Text(
            text,
            style: AppTextStyles.font16W600White(context).copyWith(
              height: isSharing ? 1.6 : 2,
              fontSize: isSharing ? 26 : 18,
              color: isSharing ? Colors.white : null,
            ),
            textAlign: TextAlign.center,
            maxLines: 10,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (subText != null && subText!.isNotEmpty)
          Text(
            subText!,
            style: AppTextStyles.font14W500Grey(context).copyWith(
              fontSize: isSharing ? 16 : 14,
              color: isSharing ? Colors.white70 : null,
            ),
            textAlign: isSharing ? TextAlign.center : TextAlign.start,
          ),
      ],
    );
  }
}
