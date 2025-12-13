import 'package:flutter/material.dart';
import 'package:sana/core/common/widgets/animated_sliver_list.dart';
import '../../domain/entities/asma_ul_husna.dart';
import 'asma_ul_husna_card.dart';

class ModernAsmaUlHusnaView extends StatelessWidget {
  final List<AsmaUlHusna> names;

  const ModernAsmaUlHusnaView({super.key, required this.names});

  @override
  Widget build(BuildContext context) {
    return AnimatedSliverList<AsmaUlHusna>(
      items: names,
      itemBuilder: (context, name, index) => AsmaUlHusnaCard(name: name),
    );
  }
}
