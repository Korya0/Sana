import 'package:flutter/material.dart';
import 'package:sana/features/salat_ala_nabi/presentation/widgets/salawat_option_card.dart';

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
    return SalawatOptionCard(
      title: title,
      isSelected: isSelected,
      onTap: onTap,
    );
  }
}
