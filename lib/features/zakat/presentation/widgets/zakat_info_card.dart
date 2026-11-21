import 'package:flutter/material.dart';

class ZakatInfoCard extends StatelessWidget {
  const ZakatInfoCard({
    super.key,
    required this.child,
    this.color,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Padding(padding: padding, child: child),
    );
  }
}
