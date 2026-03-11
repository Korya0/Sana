import 'package:flutter/material.dart';
import 'package:sana/core/common/widgets/slivers/animated_sliver_list.dart';
import 'package:sana/features/asma_ul_husna/data/models/asmaul_husna_model.dart';
import 'package:sana/features/asma_ul_husna/presentation/widgets/asma_ul_husna_card.dart';

class ModernAsmaUlHusnaView extends StatelessWidget {
  const ModernAsmaUlHusnaView({required this.names, super.key});
  final List<AsmaulHusnaModel> names;

  @override
  Widget build(BuildContext context) {
    return AnimatedSliverList<AsmaulHusnaModel>(
      dataList: names,
      itemContentBuilder: (context, name, index) => AsmaUlHusnaCard(name: name),
    );
  }
}
