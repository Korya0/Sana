import 'package:flutter/material.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppInfoShare extends StatelessWidget {
  const AppInfoShare({required this.department, super.key});
  final String department;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.v16,
        vertical: AppSpacing.v12,
      ),
      decoration: BoxDecoration(
        color: context.color.scaffoldBackgroundSubtle,
        borderRadius: BorderRadius.circular(AppSpacing.radiusS),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: AppSpacing.v12,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.v4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: context.color.primarySubtle,
                  ),
                ),
                child: SvgPicture.asset(
                  AppAssets.logo,
                  width: AppSpacing.w22.r(context),
                  height: AppSpacing.h22.r(context),
                ),
              ),
              Text(
                AppConstants.appName,
                style: AppTextStyles.font20W700(context).copyWith(
                  color: context.color.textPrimary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),

          Text(
            department,
            style: AppTextStyles.font14W700(
              context,
            ).copyWith(color: context.color.textPrimary),
          ),
        ],
      ),
    );
  }
}
