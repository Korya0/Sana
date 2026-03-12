import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/features/asma_ul_husna/data/models/asmaul_husna_model.dart';
import 'package:sana/features/asma_ul_husna/presentation/widgets/asma_ul_husna_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonizerLoadingAsmaUlHusnaView extends StatelessWidget {
  const SkeletonizerLoadingAsmaUlHusnaView({super.key});

  static const int _skeletonItemCount = 10;

  @override
  Widget build(BuildContext context) {
    final dummyList = List.generate(
      _skeletonItemCount,
      (index) => const AsmaulHusnaModel(
        id: 0,
        name: 'الله',
        meaningBrief: 'معنى مختصر للاسم الحسنى',
        meaningDetailed: 'معنى تفصيلي للاسم الحسنى',
      ),
    );

    return Skeletonizer.sliver(
      child: SliverPadding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.v16,
          vertical: AppSpacing.v16,
        ),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.v12),
              child: AsmaUlHusnaCard(name: dummyList[index]),
            );
          }, childCount: dummyList.length),
        ),
      ),
    );
  }
}
