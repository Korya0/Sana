import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/utils/context_extension.dart';

class AppSectionCard extends StatelessWidget {
  const AppSectionCard({
    required this.child,
    super.key,
    this.padding,
    this.backgroundColor,
    this.borderColor,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: padding ?? EdgeInsets.all(AppSize.p16),
    decoration: BoxDecoration(
      color: backgroundColor ?? context.color.secondaryScaffoldBackgroundColor,
      borderRadius: BorderRadius.circular(AppSize.r24),
      border: Border.all(
        color: borderColor ?? context.color.dividerColor,
        width: AppSize.borderWidth,
      ),
    ),
    child: child,
  );
}
