import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_assets.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';

class AppInfoShare extends StatelessWidget {
  const AppInfoShare({required this.department, super.key});
  final String department;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: TextDirection.rtl, // Force RTL: Right=Start, Left=End
        children: [
          // Branding (Right Side / Start)
          Row(
            spacing: 12,
            mainAxisSize: MainAxisSize.min,
            textDirection: TextDirection.rtl,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.3),
                  ),
                ),
                child: Image.asset(
                  AppAssetsImages.appLogo,
                  width: 22,
                  height: 22,
                ),
              ),
              Text(
                AppConstants.appName,
                style: AppTextStyles.font18W700White(context).copyWith(
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),

          Text(
            department,
            style: AppTextStyles.font14W600White(context),
          ),
        ],
      ),
    );
  }
}
