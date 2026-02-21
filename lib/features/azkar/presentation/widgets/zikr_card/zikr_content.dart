import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';

class ZikrContent extends StatelessWidget {

  const ZikrContent({
    required this.text, super.key,
    this.subText,
    this.isSharing = false,
  });
  final String text;
  final String? subText;
  final bool isSharing;

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
            style: isSharing
                ? AppTextStyles.font26W700GoldQuran(
                    context,
                  ).copyWith(color: Colors.white, height: 1.6)
                : AppTextStyles.font16W600White(
                    context,
                  ).copyWith(height: 2, fontSize: 18),
            textAlign: TextAlign.center,
            maxLines: isSharing ? 10 : null,
            overflow: isSharing ? TextOverflow.ellipsis : null,
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
            maxLines: isSharing ? 2 : null,
            overflow: isSharing ? TextOverflow.ellipsis : null,
          ),
      ],
    );
  }
}
