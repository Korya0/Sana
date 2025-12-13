// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/widgets/show_financial_support_dialog.dart';
import 'package:sana/core/constants/app_spacing.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:solar_icons/solar_icons.dart';

class SmartSupportCard extends StatelessWidget {
  const SmartSupportCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.horizontalP18),
      padding: EdgeInsets.all((16)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular((20)),
        gradient: const LinearGradient(
          colors: [AppColors.green, AppColors.green2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B4332).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(context),
          SizedBox(height: (16)),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'كن شريكاً في الأجر',
                style: AppTextStyles.font16W700White(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildButton(
            context,
            icon: SolarIconsBold.lightbulbMinimalistic,
            label: 'اقترح فكرة',
            onTap: () {
              context.pushNamed(
                AppRoutes.report,
                extra: {'isSuggestion': true},
              );
            },
            isPrimary: false,
          ),
        ),
        SizedBox(width: (12)),
        Expanded(
          child: _buildButton(
            context,
            icon: SolarIconsBold.cup,
            label: 'دعم مادي',
            onTap: () => showFinancialSupportDialog(context),
            isPrimary: true,
          ),
        ),
      ],
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: (10)),
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.gold : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: isPrimary
              ? null
              : Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isPrimary ? Colors.black : AppColors.gold,
              size: (20),
            ),
            SizedBox(width: (8)),
            Text(
              label,
              style: AppTextStyles.font14W600White(
                context,
              ).copyWith(color: isPrimary ? Colors.black : Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
