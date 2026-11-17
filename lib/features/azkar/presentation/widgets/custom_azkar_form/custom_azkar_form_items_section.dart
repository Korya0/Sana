import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/widgets/slivers/app_sliver_list.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_form/zikr_form_item_tile.dart';

class CustomAzkarFormItemsSection extends StatelessWidget {
  const CustomAzkarFormItemsSection({
    required this.items,
    required this.isBuiltIn,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final List<ZikrEntity> items;
  final bool isBuiltIn;
  final ValueChanged<int> onEdit;
  final ValueChanged<int> onDelete;

  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: AppSize.shp,
    sliver: AppSliverList(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final zikr = items[index];
        return ZikrFormItemTile(
          zikr: zikr,
          onEdit: () => onEdit(index),
          onDelete: (!isBuiltIn || zikr.canBeDeleted) ? () => onDelete(index) : null,
        );
      },
    ),
  );
}
