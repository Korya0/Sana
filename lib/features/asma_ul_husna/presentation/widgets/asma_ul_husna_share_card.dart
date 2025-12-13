// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sana/core/common/widgets/app_info_and_qr_code.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/asma_ul_husna/domain/entities/asma_ul_husna.dart';
import 'package:sana/core/common/widgets/islamic_divider.dart';

class AsmaUlHusnaShareCard extends StatelessWidget {
  final AsmaUlHusna name;

  const AsmaUlHusnaShareCard({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    const accentColor = AppColors.gold;

    return Container(
      width: MediaQuery.of(context).size.width - (32),
      padding: EdgeInsets.all((20)),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 16),
          // Header: ID and Name
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBackground,
                  shape: BoxShape.circle,
                  border: Border.all(color: accentColor.withOpacity(0.5)),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${name.id}',
                  style: AppTextStyles.font14W500Grey(
                    context,
                  ).copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 16),
              Text(
                name.name,
                style: AppTextStyles.font40W900Gold(
                  context,
                ).copyWith(fontSize: (32), letterSpacing: 2), // Larger Font
              ),
            ],
          ),

          SizedBox(height: 24),

          // Brief Meaning
          Text(
            name.meaningBrief,
            style: AppTextStyles.font18W700Gold(context),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),

          SizedBox(height: 24),
          const CustomAppDivider(),
          SizedBox(height: 24),

          // Detailed Meaning
          Text(
            name.meaningDetailed,
            style: AppTextStyles.font16W500White(context).copyWith(height: 1.8),
            textAlign: TextAlign.justify,
            textDirection: TextDirection.rtl,
          ),

          SizedBox(height: 32),
          const CustomAppDivider(),
          SizedBox(height: 16),

          // App Info & QR
          const AppInfoShare(),
        ],
      ),
    );
  }
}
