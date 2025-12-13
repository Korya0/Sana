import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';

class QuranCardProgress extends StatelessWidget {
  const QuranCardProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'تابع وردك اليومي',
      style: AppTextStyles.font14W400Grey(
        context,
      ).copyWith(color: Colors.white70),
    );
  }
}
