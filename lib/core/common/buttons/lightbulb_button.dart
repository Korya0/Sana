import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:solar_icons/solar_icons.dart';

class LightbulbButton extends StatelessWidget {
  const LightbulbButton({
    super.key,
    this.onPressed,
  });
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed != null
          ? () {
              unawaited(playVibrate());
              onPressed?.call();
            }
          : null,
      icon: Icon(SolarIconsBold.lightbulb, color: context.color.primary),
    );
  }
}

