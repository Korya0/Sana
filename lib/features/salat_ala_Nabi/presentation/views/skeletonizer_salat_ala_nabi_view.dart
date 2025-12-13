// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_spacing.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sana/core/common/widgets/common_sliver_app_bar.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:sana/features/salat_ala_Nabi/presentation/widgets/toggle_title_and_switch_widget.dart';

class SkeletonizerSalatAlaNabiView extends StatelessWidget {
  const SkeletonizerSalatAlaNabiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            const CommonSliverAppBar(title: 'التذكير بالصلاة على النبي ﷺ'),
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.horizontalP18,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(height: (8)),

                  // Toggle Switch
                  const ToggleTitleAndSwitchWidget(
                    title: 'تفعيل التذكير',
                    value: true,
                  ),

                  SizedBox(height: AppSpacing.betweenSections18),

                  // Notification Toggle
                  const ToggleTitleAndSwitchWidget(
                    title: 'إظهار الإشعار',
                    value: true,
                  ),

                  SizedBox(height: AppSpacing.betweenSections18 * 2),

                  // Interval Counter UI
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'التكرار كل كم دقيقة',
                        style: AppTextStyles.font16W600White(context),
                      ),
                      SizedBox(height: AppSpacing.betweenSections18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(SolarIconsBold.minusCircle, size: (32)),
                          SizedBox(width: AppSpacing.betweenSections18),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: (24),
                              vertical: (12),
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.gold,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular((12)),
                            ),
                            child: Text(
                              '15 دقيقة',
                              style: AppTextStyles.font18W700Gold(context),
                            ),
                          ),
                          SizedBox(width: AppSpacing.betweenSections18),
                          Icon(SolarIconsBold.addCircle, size: (32)),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: AppSpacing.betweenSections18 * 2),

                  // Working Hours UI
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ساعات العمل',
                        style: AppTextStyles.font16W600White(context),
                      ),
                      SizedBox(height: AppSpacing.betweenSections18),
                      _buildOption(context, 'طوال اليوم', '24 ساعة', true),
                      SizedBox(height: AppSpacing.betweenSections18 - 8),
                      _buildOption(
                        context,
                        'من 10 صباحاً إلى 10 مساءً',
                        '10 ص - 10 م',
                        false,
                      ),
                      SizedBox(height: AppSpacing.betweenSections18 - 8),
                      _buildOption(context, 'مخصص', 'حدد الوقت بنفسك', false),
                    ],
                  ),

                  SizedBox(height: AppSpacing.betweenSections18 * 2),

                  // Save Button
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: (16)),
                    ),
                    child: Text(
                      'حفظ التغييرات',
                      style: AppTextStyles.font16W700White(context),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context,
    String title,
    String subtitle,
    bool isSelected,
  ) {
    return Container(
      padding: EdgeInsets.all((16)),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular((12)),
        border: Border.all(color: AppColors.grey.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.font16W600White(context)),
              Text(subtitle, style: AppTextStyles.font12W500Grey(context)),
            ],
          ),
          if (isSelected)
            Icon(SolarIconsBold.checkCircle, color: AppColors.gold, size: (20)),
        ],
      ),
    );
  }
}
