import 'package:flutter/material.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/services/app_data.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';

class HijriAndGregorianDateWidget extends StatelessWidget {
  const HijriAndGregorianDateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final appDate = sl<AppDate>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          appDate.hijriFullString(),
          style: AppTextStyles.font12W500Gold(context),
        ),
        Text(
          appDate.gregorianFullString(),
          style: AppTextStyles.font12W500White(context).copyWith(height: 1),
        ),
      ],
    );
  }
}
