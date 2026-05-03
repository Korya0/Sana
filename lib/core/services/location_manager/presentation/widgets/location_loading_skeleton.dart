import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LocationLoadingSkeleton extends StatelessWidget {
  const LocationLoadingSkeleton({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: child,
    );
  }
}
