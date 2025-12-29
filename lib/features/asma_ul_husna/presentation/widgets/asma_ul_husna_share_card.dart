// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sana/core/common/widgets/app_info_share.dart';
import 'package:sana/core/common/widgets/islamic_divider.dart';
import 'package:sana/core/common/widgets/share_card_container.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/asma_ul_husna/data/models/asmaul_husna_model.dart';

class AsmaUlHusnaShareCard extends StatelessWidget {
  final AsmaulHusnaModel name;

  const AsmaUlHusnaShareCard({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return ShareCardContainer(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
        decoration: const BoxDecoration(color: AppColors.secondaryBackground),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldBackground,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.gold.withOpacity(0.5)),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${name.id}',
                    style: AppTextStyles.font16W500Grey(context),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  name.name,
                  style: AppTextStyles.font26W700GoldQuran(context),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    name.meaningBrief,
                    style: AppTextStyles.font14W500Grey(
                      context,
                    ).copyWith(height: 1.4),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const CustomAppDivider(),
            const SizedBox(height: 16),
            Text(
              name.meaningDetailed,
              style: AppTextStyles.font14W400WhiteHeight16(context),
              textAlign: TextAlign.justify,
              textDirection: TextDirection.rtl,
              maxLines: 10,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 48),
            const AppInfoShare(department: 'من أسماء الله الحسنى'),
          ],
        ),
      ),
    );
  }
}
