import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';

class AzkarOptionsSheetScaffold extends StatelessWidget {
  const AzkarOptionsSheetScaffold({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(
      horizontal: AppSize.p20,
      vertical: AppSize.p16,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    ),
  );
}
