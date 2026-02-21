import 'package:flutter/material.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_item_card.dart';

class AzkarListContent extends StatelessWidget {
  const AzkarListContent({
    required this.category,
    required this.onCompleted,
    super.key,
  });
  final AzkarCategoryModel category;
  final ValueChanged<int> onCompleted;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final zikr = category.array[index];
          return RepaintBoundary(
            child: ZikrItemCard(
              key: ValueKey('zikr_$index'),
              zikr: zikr,
              index: index,
              onCompleted: () {
                onCompleted(index);
              },
            ),
          );
        }, childCount: category.array.length),
      ),
    );
  }
}
