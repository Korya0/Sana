import 'package:flutter/material.dart';
import 'package:sana/core/common/common.dart';

class WorkingHourOptionItem extends StatelessWidget {
  const WorkingHourOptionItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppSelectionCard(
      title: title,
      isSelected: isSelected,
      onTap: onTap,
    );
  }
}
