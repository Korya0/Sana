import 'package:flutter/material.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';
import 'package:sana/features/azkar/data/models/zikr_model.dart';
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
    return AnimatedSliverList<ZikrModel>(
      dataList: category.array,
      keyFinder: (zikr, index) => ValueKey('zikr_${category.id}_$index'),
      itemContentBuilder: (context, zikr, index) => ZikrItemCard(
        zikr: zikr,
        index: index,
        onCompleted: () => onCompleted(index),
      ),
    );
  }
}
