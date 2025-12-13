// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/common/widgets/app_buttons.dart';
import 'package:sana/core/common/widgets/app_toast.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:solar_icons/solar_icons.dart';

void showFinancialSupportDialog(BuildContext context) {
  const String instapayUsername = 'korya01@instapay';

  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: AppColors.secondaryBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all((20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: EdgeInsets.all((16)),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColors.green, AppColors.green2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(
                SolarIconsBold.wallet,
                color: Colors.white,
                size: (32),
              ),
            ),

            SizedBox(height: (16)),

            // Title
            Text('دعم مادي', style: AppTextStyles.font18W700White(context)),

            SizedBox(height: (8)),

            // Description
            Text(
              'يمكنك دعمنا عبر InstaPay',
              style: AppTextStyles.font14W500Grey(context),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: (20)),

            // InstaPay Username Card
            Container(
              padding: EdgeInsets.symmetric(horizontal: (16), vertical: (12)),
              decoration: BoxDecoration(
                color: AppColors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular((12)),
                border: Border.all(color: AppColors.green.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.alternate_email,
                    color: AppColors.green,
                    size: (18),
                  ),
                  SizedBox(width: (8)),
                  Text(
                    instapayUsername,
                    style: AppTextStyles.font16W700White(
                      context,
                    ).copyWith(letterSpacing: 1.1),
                  ),
                ],
              ),
            ),

            SizedBox(height: (20)),

            // Copy Button
            SizedBox(
              width: double.infinity,
              child: AppPrimaryButton(
                text: 'نسخ الحساب',
                icon: SolarIconsBold.copy,
                onPressed: () async {
                  await Clipboard.setData(
                    const ClipboardData(text: instapayUsername),
                  );
                  if (context.mounted) {
                    Navigator.pop(context);
                    AppToast.show(context, 'تم نسخ الحساب بنجاح');
                  }
                },
              ),
            ),

            SizedBox(height: (12)),

            // Close Button
            SizedBox(
              width: double.infinity,
              child: AppSecondaryButton(
                text: 'إغلاق',
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
