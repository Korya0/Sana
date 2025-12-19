import 'package:flutter/material.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_item_card.dart';

class AzkarListContent extends StatelessWidget {
  final AzkarCategoryModel category;
  final List<GlobalKey> itemKeys;
  final Function(int) onCompleted;

  const AzkarListContent({
    super.key,
    required this.category,
    required this.itemKeys,
    required this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.all((16)),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final zikr = category.array[index];
          return ZikrItemCard(
            key: itemKeys[index],
            zikr: zikr,
            index: index,
            onCompleted: () {
              onCompleted(index);
            },
          );
        }, childCount: category.array.length),
      ),
    );
  }
}
