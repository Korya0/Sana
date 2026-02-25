import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:sana/core/sharing/presentation/app_info_share.dart';
import 'package:sana/core/sharing/presentation/share_card_container.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/asma_ul_husna/data/models/asmaul_husna_model.dart';
import 'package:sana/features/quran/presentation/widgets/quran_card/quran_card_background.dart';

class AsmaUlHusnaShareCard extends StatelessWidget {
  const AsmaUlHusnaShareCard({required this.name, super.key});
  final AsmaulHusnaModel name;

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
            // Background Elements from the original design
            const QuranCardBackground(),

            // Premium background addition: Large subtle "Allah" icon
            Positioned(
              left: -30,
              top: -30,
              child: Icon(
                FlutterIslamicIcons.solidAllah,
                size: 200,
                color: Colors.white.withValues(alpha: 0.03),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top Section: ID, Name and Brief Meaning
                  Row(
                    children: [
                      // Enhanced ID Circle
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.gold.withValues(alpha: 0.5),
                            width: 1.5,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${name.id}',
                          style: AppTextStyles.font16W700Gold(context).copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // The Name with Premium Font
                      Text(
                        name.name,
                        style: AppTextStyles.font26W700GoldQuran(context)
                            .copyWith(
                              fontSize: 34,
                              height: 1,
                            ),
                      ),
                      const SizedBox(width: 16),
                      // Brief Meaning
                      Expanded(
                        child: Text(
                          name.meaningBrief,
                          style: AppTextStyles.font16W500White(context)
                              .copyWith(
                                color: AppColors.gold.withValues(alpha: 0.9),
                                height: 1.2,
                              ),
                          textAlign: TextAlign.right,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Decorative Divider with Islamic Icon
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: AppColors.gold.withValues(alpha: 0.2),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(
                          FlutterIslamicIcons.solidIftar,
                          color: AppColors.gold,
                          size: 18,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: AppColors.gold.withValues(alpha: 0.2),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Detailed Meaning (The Main Content)
                  Text(
                    name.meaningDetailed,
                    style: AppTextStyles.font14W400WhiteHeight16(context)
                        .copyWith(
                          fontSize: 18,
                          color: Colors.white.withValues(alpha: 0.95),
                          height: 1.7,
                        ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),

                  const SizedBox(height: 48),

                  // Footer
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
