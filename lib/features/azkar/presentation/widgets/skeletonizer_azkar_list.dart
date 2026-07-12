import 'package:flutter/material.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_card/zikr_item_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonizerAzkarList extends StatelessWidget {
  const SkeletonizerAzkarList({super.key});

  static const _dummyZikr = ZikrEntity(
    id: 1,
    
    text:
        'سبحان الله وبحمده سبحان الله العظيم سبحان الله وبحمده سبحان الله العظيم',
    description: 'يقال ثلاث مرات في الصباح والمساء',
    count: 3,
    reference: '',
    
  );

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
            return const ZikrItemCardContent(
              zikr: _dummyZikr,
              remainingCount: 3,
              progress: 0,
              isCompleted: false,
              fontSize: 18,
            );
          },
        ),
      ),
    );
  }
}
