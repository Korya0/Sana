import 'package:flutter/material.dart';
import 'package:sana/core/common/slivers/common_sliver_app_bar.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/features/salat_ala_Nabi/presentation/widgets/toggle_title_and_switch_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:solar_icons/solar_icons.dart';

class SkeletonizerSalatAlaNabiView extends StatelessWidget {
  const SkeletonizerSalatAlaNabiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            const CommonSliverAppBar(title: 'التذكير بالصلاة على النبي ﷺ'),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.v18,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: AppSpacing.v8),

                  // Toggle Switch
                  const ToggleTitleAndSwitchWidget(
                    title: 'تفعيل التذكير',
                    value: true,
                  ),

                  const SizedBox(height: AppSpacing.v18),

                  // Notification Toggle
                  const ToggleTitleAndSwitchWidget(
                    title: 'إظهار الإشعار',
                    value: true,
                  ),

                  const SizedBox(height: AppSpacing.v18 * 2),

                  // Interval Counter UI
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'التكرار كل كم دقيقة',
                        style: AppTextStyles.font16W600White(context),
                      ),
                      const SizedBox(height: AppSpacing.v18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(SolarIconsBold.minusCircle, color: AppColors.iconPrimary, size: 32),
                          const SizedBox(width: AppSpacing.v18),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.v24,
                              vertical: AppSpacing.v12,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.primary),
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusM,
                              ),
                            ),
                            child: Text(
                              '15 دقيقة',
                              style: AppTextStyles.font18W700primary(context),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.v18),
                          const Icon(SolarIconsBold.addCircle, color: AppColors.iconPrimary, size: 32),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.v18 * 2),

                  // Working Hours UI
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ساعات العمل',
                        style: AppTextStyles.font16W600White(context),
                      ),
                      const SizedBox(height: AppSpacing.v18),
                      _buildOption(context, 'طوال اليوم', '24 ساعة', true),
                      const SizedBox(height: AppSpacing.v18 - 8),
                      _buildOption(
                        context,
                        'من 10 صباحاً إلى 10 مساءً',
                        '10 ص - 10 م',
                        false,
                      ),
                      const SizedBox(height: AppSpacing.v18 - 8),
                      _buildOption(context, 'مخصص', 'حدد الوقت بنفسك', false),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.v18 * 2),

                  // Save Button
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.v16,
                      ),
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
      padding: const EdgeInsets.all(AppSpacing.v16),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        border: Border.all(color: AppColors.grey.withValues(alpha: 0.3)),
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
            const Icon(
              SolarIconsBold.checkCircle,
              color: AppColors.iconPrimary,
              size: 20,
            ),
        ],
      ),
    );
  }
}
