import 'package:flutter/material.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_form/zikr_reorder_list.dart';

class CustomAzkarFormItemsSection extends StatelessWidget {
  const CustomAzkarFormItemsSection({
    required this.items,
    required this.isBuiltIn,
    required this.onEdit,
    required this.onDelete,
    required this.onReorder,
    required this.topInset,
    super.key,
  });

  final List<ZikrEntity> items;
  final bool isBuiltIn;
  final ValueChanged<int> onEdit;
  final ValueChanged<int> onDelete;
  final ReorderCallback onReorder;

  // Pinned app bar height
  final double topInset;

  @override
  Widget build(BuildContext context) => ZikrReorderList(
    items: items,
    isBuiltIn: isBuiltIn,
    onEdit: onEdit,
    onDelete: onDelete,
    onReorder: onReorder,
    topInset: topInset,
  );
}
