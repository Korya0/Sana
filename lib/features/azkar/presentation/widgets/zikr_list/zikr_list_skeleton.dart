import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/slivers/app_sliver_list.dart';
import 'package:sana/features/azkar/domain/entities/azkar_tasbeeh_settings_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/zikr_progress.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_card/zikr_item_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ZikrListSkeleton extends StatelessWidget {
  const ZikrListSkeleton({super.key});

  static const ZikrEntity _dummyZikr = ZikrEntity(
    id: 1,
    text: AppStrings.loading,
    description: AppStrings.loading,
    count: AppConstants.skeletonZikrRepetitions,
  );

  @override
  Widget build(BuildContext context) => Skeletonizer.sliver(
    child: SliverMainAxisGroup(
      slivers: [
        AppSliverList(
          padding: AppSize.shp,
          itemCount: AppConstants.azkarListSkeletonCount,
          itemBuilder: (context, index) => const ZikrItemCardContent(
            zikr: _dummyZikr,
            progress: ZikrProgress(
              completedCount: 0,
              totalCount: AppConstants.skeletonZikrRepetitions,
              remaining: AppConstants.skeletonZikrRepetitions,
              isCompleted: false,
              canReset: false,
            ),
            fontSize: AzkarTasbeehSettingsEntity.defaultFontSize,
          ),
        ),
        // Bottom gap
        SliverToBoxAdapter(child: AppGap.h(AppSize.sbp)),
      ],
    ),
  );
}
