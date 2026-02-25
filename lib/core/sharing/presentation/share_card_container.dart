import 'package:flutter/material.dart';

class ShareCardContainer extends StatelessWidget {
  const ShareCardContainer({required this.child, super.key, this.width});
  final Widget child;
  final double? width;

  @override
  Widget build(BuildContext context) {
    // Fixed width for social media consistency
    final cardWidth = width ?? 500.0;

    return Container(
      width: cardWidth,
      // Absolute safety: Prevent expansion beyond 800px vertical
      constraints: const BoxConstraints(maxHeight: 800),
      // Ensure nothing bleeds out if content hits the limit
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(),
      child: child,
    );
  }
}
