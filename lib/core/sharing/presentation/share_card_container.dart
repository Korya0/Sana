import 'package:flutter/material.dart';

class ShareCardContainer extends StatelessWidget {
  const ShareCardContainer({
    required this.child,
    super.key,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      // Fixed width for social media consistency
      width: 500,
      // Absolute safety: Prevent expansion beyond 800px vertical
      constraints: const BoxConstraints(maxHeight: 800),
      // Ensure nothing bleeds out if content hits the limit
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(),
      child: child,
    );
  }
}
