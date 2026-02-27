import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:sana/core/common/widgets/app_buttons.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';

class SuccessReportDialog {
  static void show(BuildContext context) {
    unawaited(
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          backgroundColor: AppColors.secondaryBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/json/success_check.json',
                  width: 150,
                  height: 150,
                  repeat: false,
                ),
                const SizedBox(height: 16),
                Text(
                  'تم الإرسال بنجاح',
                  style: AppTextStyles.font18W700White(context),
                ),
                const SizedBox(height: 8),
                Text(
                  'شكراً لمساهمتك في تحسين تطبيق سنا، جزاك الله خيراً.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font14W400Grey(context),
                ),
                const SizedBox(height: 24),
                AppPrimaryButton(
                  text: 'إغلاق',
                  onPressed: () {
                    context.pop(); // Close Dialog
                    context.pop(); // Go back to previous screen
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
