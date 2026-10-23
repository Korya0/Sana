import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/widgets/slivers/app_sliver_list.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
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
    child: AppSliverList(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.p16,
        vertical: AppSize.p16,
      ),
      itemCount: AppConstants.azkarListSkeletonCount,
      itemBuilder: (context, index) => ZikrItemCardContent(
        zikr: _dummyZikr,
        remainingCount: _dummyZikr.count,
        progress: AppConstants.progressStart,
        isCompleted: false,
        fontSize: ReadingSettingsEntity.defaultFontSize,
      ),
    ),
  );
}
