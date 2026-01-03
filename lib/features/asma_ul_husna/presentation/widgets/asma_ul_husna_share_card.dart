// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sana/core/common/widgets/app_info_share.dart';
import 'package:sana/core/common/widgets/islamic_divider.dart';
import 'package:sana/core/common/widgets/share_card_container.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/asma_ul_husna/data/models/asmaul_husna_model.dart';

import 'package:sana/features/quran/presentation/widgets/quran_card/quran_card_background.dart';

class AsmaUlHusnaShareCard extends StatelessWidget {
  final AsmaulHusnaModel name;

  const AsmaUlHusnaShareCard({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return ShareCardContainer(
      child: Container(
        width: double.infinity,
        decoration: QuranCardBackground.decoration.copyWith(
          borderRadius: BorderRadius.zero,
          boxShadow: [],
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const QuranCardBackground(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
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
                          color: AppColors.scaffoldBackground.withOpacity(0.3),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.gold.withOpacity(0.5),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${name.id}',
                          style: AppTextStyles.font16W500Grey(
                            context,
                          ).copyWith(color: Colors.white),
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
                          ).copyWith(height: 1.4, color: Colors.white70),
                          textAlign: TextAlign.right,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const CustomAppDivider(),
                  const SizedBox(height: 16),
                  Text(
                    name.meaningDetailed,
                    style: AppTextStyles.font14W400WhiteHeight16(
                      context,
                    ).copyWith(fontSize: 16),
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
          ],
        ),
      ),
    );
  }
}
