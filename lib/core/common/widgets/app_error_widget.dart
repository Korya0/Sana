import 'package:flutter/material.dart';
import 'package:sana/core/common/widgets/app_buttons.dart';
import 'package:sana/core/constants/app_design.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:solar_icons/solar_icons.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    this.title,
    super.key,
    this.message,
    this.onRetry,
  });
  final String? title;
  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesign.horizontalP18,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              if (title != null)
                Text(
                  title!,
                  style: AppTextStyles.font18W700White(context),
                  textAlign: TextAlign.center,
                ),

              const SizedBox(height: AppDesign.betweenSections18),

              // Message
              if (message != null)
                Text(
                  message!,
                  style: AppTextStyles.font16W500Grey(context),
                  textAlign: TextAlign.center,
                ),

              const SizedBox(height: AppDesign.betweenSections18 * 2),

              // Retry Button (if provided)
              if (onRetry != null)
                AppPrimaryButton(
                  text: 'حاول مرة أخرى',
                  icon: SolarIconsBold.refresh,
                  onPressed: onRetry!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
