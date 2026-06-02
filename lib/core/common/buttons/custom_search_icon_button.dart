import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/utils/app_feedback.dart';
import 'package:solar_icons/solar_icons.dart';

class CustomSearchIconButton extends StatelessWidget {
  const CustomSearchIconButton({
    required this.onToggleSearch,
    super.key,
  });

  final VoidCallback onToggleSearch;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        SolarIconsOutline.magnifier,
        color: context.color.primary,
      ),
      onPressed: () {
        unawaited(AppFeedback.playVibrate());
        onToggleSearch();
      },
    );
  }
}
