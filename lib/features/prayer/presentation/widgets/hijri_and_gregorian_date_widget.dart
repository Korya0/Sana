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
      children: [
        Text(
          appDate.hijriFullString(),
          style: AppTextStyles.font14W600Gold(context),
        ),
        Text(
          appDate.gregorianFullString(),
          style: AppTextStyles.font14W600White(context),
        ),
      ],
    );
  }
}
