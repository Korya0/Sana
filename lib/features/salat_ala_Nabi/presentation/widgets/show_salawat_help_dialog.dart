// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sana/core/common/widgets/app_buttons.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:solar_icons/solar_icons.dart';

void showSalawatHelpDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: AppColors.secondaryBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all((20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Center(
              child: Text(
                'ملاحظات مهمة',
                style: AppTextStyles.font18W700White(context),
              ),
            ),

            SizedBox(height: (20)),

            // Warning Card
            Container(
              padding: EdgeInsets.all((12)),
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.1),
                borderRadius: BorderRadius.circular((12)),
                border: Border.all(color: AppColors.gold.withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    SolarIconsBold.infoCircle,
                    color: AppColors.gold,
                    size: (20),
                  ),
                  SizedBox(width: (12)),
                  Expanded(
                    child: Text(
                      'قد يتأخر التذكير أحياناً بسبب قيود نظام الهاتف',
                      style: AppTextStyles.font14W600White(
                        context,
                      ).copyWith(color: AppColors.gold, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: (20)),

            // Instructions
            Text(
              'لضمان استمرار الخدمة:',
              style: AppTextStyles.font16W700White(context),
            ),

            SizedBox(height: (12)),

            _buildInstructionItem(context, 'افتح التطبيق يومياً'),

            SizedBox(height: (8)),

            _buildInstructionItem(context, 'أعد تفعيل الخدمة من حين لآخر'),

            SizedBox(height: (8)),

            _buildInstructionItem(
              context,
              'تأكد من عدم إيقاف التطبيق من إعدادات الهاتف',
            ),

            SizedBox(height: (24)),

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
        margin: EdgeInsets.only(top: (4)),
        width: (6),
        height: (6),
        decoration: BoxDecoration(
          color: AppColors.green,
          shape: BoxShape.circle,
        ),
      ),
      SizedBox(width: (12)),
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
