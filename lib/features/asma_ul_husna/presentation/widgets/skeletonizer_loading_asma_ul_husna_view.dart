import 'package:flutter/material.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/features/asma_ul_husna/domain/entities/asma_ul_husna_entity.dart';
import 'package:sana/features/asma_ul_husna/presentation/widgets/asma_ul_husna_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonizerLoadingAsmaUlHusnaView extends StatelessWidget {
  const SkeletonizerLoadingAsmaUlHusnaView({super.key});

  static const int _skeletonItemCount = 10;
  static final List<AsmaUlHusnaEntity> _dummyList = List.generate(
    _skeletonItemCount,
    (index) => const AsmaUlHusnaEntity(
      id: 0,
      name: AppStrings.skeletonAsmaName,
      meaningBrief: AppStrings.skeletonAsmaMeaningBrief,
      meaningDetailed: AppStrings.skeletonAsmaMeaningDetailed,
    ),
  );

  @override
  Widget build(BuildContext context) {
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
              child: AsmaUlHusnaCard(
                name: _dummyList[index],
                onSharePressed: () {},
                onCopyPressed: () {},
              ),
            );
          }, childCount: _dummyList.length),
        ),
      ),
    );
  }
}
