// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sana/core/common/widgets/app_buttons.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:solar_icons/solar_icons.dart';

void showQiblaHelpDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: AppColors.secondaryBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all((20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Center(
              child: Text(
                'إرشادات استخدام البوصلة',
                style: AppTextStyles.font18W700White(context),
              ),
            ),

            const SizedBox(height: (20)),

            // Warning Card
            Container(
              padding: const EdgeInsets.all((12)),
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.1),
                borderRadius: BorderRadius.circular((12)),
                border: Border.all(color: AppColors.gold.withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    SolarIconsBold.dangerTriangle,
                    color: AppColors.gold,
                    size: (20),
                  ),
                  const SizedBox(width: (12)),
                  Expanded(
                    child: Text(
                      'إذا لم يتحرك السهم، فجهازك قد لا يحتوي على حساس البوصلة',
                      style: AppTextStyles.font14W600White(
                        context,
                      ).copyWith(color: AppColors.gold, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: (20)),

            // Instructions
            Text(
              'للحصول على أفضل دقة:',
              style: AppTextStyles.font16W700White(context),
            ),

            const SizedBox(height: (12)),

            _buildInstructionItem(
              context,
              'ابعد أي أجهزة إلكترونية أو جراب به معدن عن الهاتف (سماعات، ساعة ذكية، إلخ)',
            ),

            const SizedBox(height: (8)),

            _buildInstructionItem(context, 'ضع الهاتف على سطح مستوٍ'),

            const SizedBox(height: (8)),

            _buildInstructionItem(
              context,
              'لف الهاتف ببطء حتى يثبت السهم على اتجاه القبلة',
            ),

            const SizedBox(height: (24)),

            // Close Button
            SizedBox(
              width: double.infinity,
              child: AppSecondaryButton(
                text: 'فهمت',
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildInstructionItem(BuildContext context, String text) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        margin: const EdgeInsets.only(top: (4)),
        width: (6),
        height: (6),
        decoration: const BoxDecoration(
          color: AppColors.green,
          shape: BoxShape.circle,
        ),
      ),
      const SizedBox(width: (12)),
      Expanded(
        child: Text(
          text,
          style: AppTextStyles.font14W500Grey(
            context,
          ).copyWith(color: AppColors.textWhite.withAlpha(200), height: 1.5),
        ),
      ),
    ],
  );
}
