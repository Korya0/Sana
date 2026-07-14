import 'package:flutter/material.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:solar_icons/solar_icons.dart';

class AppDeleteButton extends StatelessWidget {
  const AppDeleteButton({
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        SolarIconsBold.trashBinTrash,
        color: context.color.error,
      ),
      color: context.color.error,
    );
  }
}
