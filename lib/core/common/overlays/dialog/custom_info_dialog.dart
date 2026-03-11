//bbbbb
// ignore_for_file: comment_references

/// [CustomInfoDialog]
/// - الوظيفة الأساسية: نافذة منسدلة (Dialog) مصممة لعرض معلومات وإرشادات معينة للمستخدم (تنبيه أو تعليمات).
/// - مميزاتها: تعرض صندوق تنبيه (Warning Card) ثم قائمة بالتعليمات (Instructions) بخطوات مرتبة،وزر للإغلاق (فهمت ذلك).
/// - الاستخدام (في التطبيق عبر الجاهز بالأسفل):
///   * [showQiblaHelpDialog]: شرح أسباب تعطل البوصلة وكيفية تحسين اتجاه القبلة (qibla_view).
///   * [showSalawatHelpDialog]: شرح تأخر التنبيهات بسبب النظام وكيفية ضمان تفعيلها (salat_ala_nabi_view).
///   * [showHijriVerificationDialog]: رسالة تأكيد لحل مشكلة التاريخ الهجري مع الرؤية في البلد (hijri_and_gregorian_date_widget).
library;

import 'package:flutter/material.dart';
import 'package:sana/core/common/buttons/app_buttons.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/common/overlays/dialog/custom_dialog.dart';
import 'package:solar_icons/solar_icons.dart';

Future<void> showCustomInfoDialog({
  required BuildContext context,
  required String title,
  required String warningText,
  required String instructionsTitle,
  required List<String> instructions,
  IconData warningIcon = SolarIconsBold.infoCircle,
  String buttonText =
      AppStrings.iUnderstood, // Default close text usually 'فهمت ذلك'
}) async {
  await showCustomDialog<void>(
    context: context,
    padding: const EdgeInsets.all(20),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Center(
          child: Text(
            title,
            style: AppTextStyles.font18W700White(context),
          ),
        ),

        const SizedBox(height: 20),

        // Warning Card
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.gold.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                warningIcon,
                color: AppColors.gold,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  warningText,
                  style: AppTextStyles.font14W600White(context).copyWith(
                    color: AppColors.gold,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Instructions
        Text(
          instructionsTitle,
          style: AppTextStyles.font16W700White(context),
        ),

        const SizedBox(height: 12),

        ...instructions.expand(
          (instruction) => [
            _buildInstructionItem(context, instruction),
            const SizedBox(height: 8),
          ],
        ),

        const SizedBox(height: 16),

        // Close Button
        SizedBox(
          width: double.infinity,
          child: AppSecondaryButton(
            text: buttonText,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    ),
  );
}

Widget _buildInstructionItem(BuildContext context, String text) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        margin: const EdgeInsets.only(top: 4),
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          color: AppColors.green,
          shape: BoxShape.circle,
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Text(
          text,
          style: AppTextStyles.font14W500Grey(context).copyWith(
            color: AppColors.textWhite.withAlpha(200),
            height: 1.5,
          ),
        ),
      ),
    ],
  );
}
