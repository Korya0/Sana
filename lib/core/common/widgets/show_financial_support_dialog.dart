import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/common/widgets/app_toast.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> showFinancialSupportDialog(BuildContext context) async {
  const instapayUsername = 'korya01@instapay';
  const paypalId = 'paypal.me/MahmoudMohamed223211';

  await showDialog<void>(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: AppColors.secondaryBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: AppColors.gold.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Account Containers
            _buildSupportItem(
              context,
              title: 'InstaPay | دعم من داخل مصر',
              value: instapayUsername,
            ),
            const SizedBox(height: 16),
            _buildSupportItem(
              context,
              title: 'PayPal | دعم من خارج مصر',
              value: paypalId,
              isLink: true,
            ),

            const SizedBox(height: 32),

            // Close Action
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Text(
                'إغلاق',
                style: AppTextStyles.font14W600White(
                  context,
                ).copyWith(color: AppColors.textGrey),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildSupportItem(
  BuildContext context, {
  required String title,
  required String value,
  bool isLink = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: AppTextStyles.font10W500Grey(
          context,
        ).copyWith(color: AppColors.textPrimary, letterSpacing: 0.2),
      ),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
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
                          color: AppColors.textPrimary,
                          decoration: TextDecoration.underline,
                        )
                      : AppTextStyles.font14W600White(context),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: value));
                if (context.mounted) {
                  AppToast.show(context, 'تم النسخ بنجاح');
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'نسخ',
                  style: AppTextStyles.font12W600primary(
                    context,
                  ).copyWith(color: AppColors.gold),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
