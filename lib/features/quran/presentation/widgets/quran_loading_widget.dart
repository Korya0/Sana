import 'package:flutter/material.dart';
import 'package:sana/core/utils/utils.dart';

/// Uses CircularProgressIndicator instead of Skeletonizer — library init has no skeleton-able UI.
class QuranLoadingWidget extends StatelessWidget {
  const QuranLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.color.secondaryScaffoldBackgroundColor,
      child: Center(
        child: CircularProgressIndicator(color: context.color.primary),
      ),
    );
  }
}
