import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/utils/context_extension.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) => Divider(
    height: AppSize.dividerThickness,
    thickness: AppSize.dividerThickness,
    color: context.color.dividerColor,
  );
}
