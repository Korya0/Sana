import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';

class ZakatInfoCard extends StatelessWidget {
  const ZakatInfoCard({
    super.key,
    required this.child,
    this.color,
    this.padding,
  });

  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.r16),
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.all(AppSize.p16),
        child: child,
      ),
    );
  }
}
