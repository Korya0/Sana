import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
          context.pop();
          unawaited(playVibrate());
        }
      },
      child: const AppArrowIcon(
        direction: AppArrowDirection.right,
        size: 24,
      ),
    );
  }
}
