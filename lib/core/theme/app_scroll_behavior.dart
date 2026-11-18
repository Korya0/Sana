import 'package:flutter/material.dart';

class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  // Clamping everywhere: no bounce on reaching the edge
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const ClampingScrollPhysics();

  // No glow or stretch at the edges
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) => child;
}
