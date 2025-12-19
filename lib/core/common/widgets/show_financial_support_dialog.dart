// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/common/widgets/app_buttons.dart';
import 'package:sana/core/common/widgets/app_toast.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:url_launcher/url_launcher.dart';

void showFinancialSupportDialog(BuildContext context) {
  const String instapayUsername = 'korya01@instapay';
  const String paypalId = 'paypal.me/MahmoudMohamed223211';

  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: AppColors.secondaryBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColors.green, AppColors.green2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(
                SolarIconsBold.wallet,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text('دعم مادي', style: AppTextStyles.font18W700White(context)),
            const SizedBox(height: 8),
            Text(
              'يمكنك دعم استمرار المشروع عبر الوسائل التالية',
              style: AppTextStyles.font14W500Grey(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // InstaPay Section
            _buildSupportCard(
              context,
              title: 'InstaPay',
              value: instapayUsername,
              icon: Icons.alternate_email,
            ),
            const SizedBox(height: 12),

            // PayPal Section
            _buildSupportCard(
              context,
              title: 'PayPal',
              value: paypalId,
              icon: Icons.payment,
              isLink: true,
            ),

            const SizedBox(height: 20),

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

Widget _buildSupportCard(
  BuildContext context, {
  required String title,
  required String value,
  required IconData icon,
  bool isLink = false,
}) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.white.withOpacity(0.05),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.white.withOpacity(0.1)),
    ),
    child: Row(
      children: [
        Icon(icon, color: AppColors.gold, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.font12W500Grey(context)),
              GestureDetector(
                onTap: isLink
                    ? () async {
                        final url = Uri.parse('https://$value');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      }
                    : null,
                child: Text(
                  value,
                  style: isLink
                      ? AppTextStyles.font14W600White(context).copyWith(
                          color: Colors.blueAccent,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.blueAccent,
                        )
                      : AppTextStyles.font14W600White(context),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: value));
            if (context.mounted) {
              AppToast.show(context, 'تم النسخ بنجاح');
            }
          },
          icon: const Icon(
            SolarIconsBold.copy,
            color: AppColors.gold,
            size: 20,
          ),
        ),
      ],
    ),
  );
}
