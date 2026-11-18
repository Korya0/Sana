import 'package:flutter/material.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_preset_grid.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TasbeehPresetGridSkeleton extends StatelessWidget {
  const TasbeehPresetGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) => Skeletonizer(
    child: IgnorePointer(
      child: TasbeehPresetGrid(onSelect: (_) {}, onCustomTap: () {}),
    ),
  );
}
