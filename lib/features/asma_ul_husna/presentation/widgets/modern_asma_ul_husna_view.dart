import 'package:flutter/material.dart';
import 'package:sana/core/common/widgets/animated_sliver_list.dart';
import 'package:sana/features/asma_ul_husna/data/models/asmaul_husna_model.dart';
import 'package:sana/features/asma_ul_husna/presentation/widgets/asma_ul_husna_card.dart';

class ModernAsmaUlHusnaView extends StatelessWidget {
  final List<AsmaulHusnaModel> names;

  const ModernAsmaUlHusnaView({super.key, required this.names});

  @override
  Widget build(BuildContext context) {
    return AnimatedSliverList<AsmaulHusnaModel>(
      items: names,
      itemBuilder: (context, name, index) => AsmaUlHusnaCard(name: name),
    );
  }
}
