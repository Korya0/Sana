import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_assets.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';

class AppInfoShare extends StatelessWidget {
  final String? department;

  const AppInfoShare({super.key, this.department});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: TextDirection.rtl, // Force RTL: Right=Start, Left=End
        children: [
          // Branding (Right Side / Start)
          Row(
            mainAxisSize: MainAxisSize.min,
            textDirection: TextDirection.rtl,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.gold.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Image.asset(
                  AppAssetsImages.appLogo,
                  width: 22,
                  height: 22,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'سَنَا',
                style: AppTextStyles.font16W700White(context).copyWith(
                  fontSize: 18,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),

          // Department Sourcing (Left Side / End)
          if (department != null)
            Text(
              department!,
              style: AppTextStyles.font14W500Grey(
                context,
              ).copyWith(color: AppColors.white.withOpacity(0.6), fontSize: 12),
            ),
        ],
      ),
    );
  }
}
