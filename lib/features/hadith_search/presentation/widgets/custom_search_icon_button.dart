import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sana/core/utils/utils.dart';
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
        SolarIconsBold.magnifier,
        color: context.color.primary,
      ),
      onPressed: () {
        unawaited(playVibrate());
        onToggleSearch();
      },
    );
  }
}
