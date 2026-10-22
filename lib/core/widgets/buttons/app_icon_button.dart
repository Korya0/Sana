import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';

/// Icon-only pressable.
///
/// The icon keeps its visual size; the box around it is at least
/// [AppConstants.minTapTarget] so the target never shrinks below the
/// accessibility floor on small screens.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.icon,
    required this.onPressed,
    super.key,
    this.tooltip,
    this.onLongPress,
    this.color,
    this.size,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;

  /// Optional: shown on hover (web/desktop) and on long press (mobile).
  /// When present it is also the screen-reader label.
  final String? tooltip;

  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final target = AppSize.w48 < AppConstants.minTapTarget
        ? AppConstants.minTapTarget
        : AppSize.w48;

    final button = AppPressable(
      onPressed: onPressed,
      onLongPress: onLongPress,
      semanticLabel: tooltip,
      disabledOpacity: AppConstants.opacityDisabled,
      child: SizedBox(
        width: target,
        height: target,
        child: Center(
          child: Icon(
            icon,
            size: size ?? AppSize.icon24,
            color: color ?? context.color.iconPrimary,
          ),
        ),
      ),
    );

    if (tooltip == null) return button;

    return Tooltip(
      message: tooltip!,
      // AppPressable already carries the label; without this the reader can
      // announce the same string twice (label + tooltip).
      excludeFromSemantics: true,
      child: button,
    );
  }
}
