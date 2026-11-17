import 'package:flutter/material.dart';
import 'package:sana/features/azkar/presentation/widgets/common/counter_ring.dart';

class ZikrCounter extends StatelessWidget {
  const ZikrCounter({
    required this.completedCount,
    required this.totalCount,
    super.key,
  });

  final int completedCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) => CounterRing(
    currentCount: completedCount,
    targetCount: totalCount,
    numberKeyBuilder: (_) => const ValueKey('zikr_counter_number'),
    doneKey: const ValueKey('zikr_counter_done'),
  );
}
