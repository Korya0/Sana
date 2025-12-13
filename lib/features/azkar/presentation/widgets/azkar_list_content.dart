import 'package:flutter/material.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_item_card.dart';

class AzkarListContent extends StatelessWidget {
  final AzkarCategory category;
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
          final zikr = category.azkar[index];
          return ZikrItemCard(
            key: itemKeys[index],
            zikr: zikr,
            index: index,
            onCompleted: () {
              onCompleted(index);
            },
          );
        }, childCount: category.azkar.length),
      ),
    );
  }
}
