import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sana/core/utils/app_feedback.dart';
import 'package:sana/core/common/widgets/app_arrow_icon.dart';

class CustomArrowBackButton extends StatelessWidget {
  const CustomArrowBackButton({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        unawaited(AppFeedback.playLightHaptic());
        if (onTap != null) {
          onTap!();
        } else {
          Navigator.of(context).pop();
        }
      },
      child: const AppArrowIcon(
        direction: AppArrowDirection.right,
        size: 24,
      ),
    );
  }
}
