import 'package:flutter/material.dart';
import 'package:sana/features/asma_ul_husna/data/models/asmaul_husna_model.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'asma_ul_husna_card.dart';

class SkeletonizerLoadingAsmaUlHusnaView extends StatelessWidget {
  const SkeletonizerLoadingAsmaUlHusnaView({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyList = List.generate(
      10,
      (index) => const AsmaulHusnaModel(
        id: 0,
        name: 'الله',
        meaningBrief: 'معنى مختصر للاسم الحسنى',
        meaningDetailed: 'معنى تفصيلي للاسم الحسنى',
      ),
    );

    return Skeletonizer.sliver(
      enabled: true,
      child: SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: AsmaUlHusnaCard(name: dummyList[index]),
            );
          }, childCount: dummyList.length),
        ),
      ),
    );
  }
}
