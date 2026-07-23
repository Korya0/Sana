import 'package:sana/core/routing/app_navigator.dart';
import 'package:sana/core/constants/app_spacing.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sana/core/common/widgets/app_arrow_icon.dart';
import 'package:sana/core/utils/utils.dart';

class CustomArrowBackButton extends StatelessWidget {
  const CustomArrowBackButton({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        } else {
          AppNavigator.pop(context);
          unawaited(playVibrate());
        }
      },
      child: AppArrowIcon(
        direction: AppArrowDirection.right,
        size: AppSpacing.s24.r(context),
      ),
    );
  }
}
