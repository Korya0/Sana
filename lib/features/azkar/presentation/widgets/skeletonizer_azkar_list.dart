import 'package:flutter/material.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_card/zikr_actions_row.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_card/zikr_content.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonizerAzkarList extends StatelessWidget {
  const SkeletonizerAzkarList({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.sliver(
      child: SliverPadding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.v16.r(context),
          vertical: AppSpacing.v16.r(context),
        ),
        sliver: SliverList.builder(
          itemCount: 2,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.v12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
                color: context.color.secondaryScaffoldBackgroundColor
                    .withValues(
                      alpha: 0.4,
                    ),
                border: Border.all(
                  color: context.color.primary.withValues(alpha: 0.15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.v20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const ZikrContent(
                      text:
                          'محتوى تجريبي طويل ليظهر بنفس المساحة تماما محتوى تجريبي طويل ليظهر بنفس المساحة تماما',
                      subText: 'محتوى تجريبي للوصف أو التخريج يظهر هنا',
                    ),
                    const AppGap.h(AppSpacing.v24),
                    const CustomAppDivider(),
                    const AppGap.h(AppSpacing.v24),
                    ZikrActionsRow(
                      remainingCount: 3,
                      progress: 0,
                      isCompleted: false,
                      onShare: () {},
                      onCopy: () {},
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
