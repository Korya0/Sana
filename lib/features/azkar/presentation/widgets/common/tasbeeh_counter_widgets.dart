import 'package:flutter/material.dart';
import 'package:sana/features/azkar/presentation/widgets/common/counter_ring.dart';

class TasbeehCounter extends StatelessWidget {
  const TasbeehCounter({
    required this.currentCount,
    required this.targetCount,
    super.key,
    this.dimension,
    this.strokeWidth,
    this.numberStyle,
  });

  final int currentCount;
  final int? targetCount;
  final double? dimension;
  final double? strokeWidth;
  final TextStyle? numberStyle;

  @override
  Widget build(BuildContext context) => CounterRing(
    currentCount: currentCount,
    targetCount: targetCount,
    dimension: dimension,
    strokeWidth: strokeWidth,
    numberStyle: numberStyle,
    numberKeyBuilder: (display) => ValueKey('tasbeeh_counter_$display'),
    doneKey: const ValueKey('tasbeeh_counter_done'),
  );
}
