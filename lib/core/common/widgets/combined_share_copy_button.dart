import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:solar_icons/solar_icons.dart';

class CombinedShareCopyButton extends StatefulWidget {
  const CombinedShareCopyButton({
    required this.onSharePressed,
    required this.onCopyPressed,
    super.key,
    this.iconSize,
    this.isCombined = true, // افتراضياً يكون مدمجاً
  });

  final VoidCallback onSharePressed;
  final VoidCallback onCopyPressed;
  final double? iconSize;
  final bool isCombined;

  @override
  State<CombinedShareCopyButton> createState() =>
      _CombinedShareCopyButtonState();
}

class _CombinedShareCopyButtonState extends State<CombinedShareCopyButton> {
  bool _showShareIcon = false;

  void _handleLongPress() {
    if (!widget.isCombined) return;
    unawaited(HapticFeedback.mediumImpact());

    widget.onSharePressed();
    setState(() {
      _showShareIcon = true;
    });
    unawaited(
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _showShareIcon = false;
          });
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final iconSize = widget.iconSize ?? 22;

    if (!widget.isCombined) {
      // الحالة المنفصلة: زرين بجانب بعض
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: widget.onCopyPressed,
            icon: Icon(
              SolarIconsOutline.copy,
              color: AppColors.gold,
              size: iconSize,
            ),
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
          ),
          IconButton(
            onPressed: widget.onSharePressed,
            icon: Icon(
              SolarIconsOutline.share,
              color: AppColors.gold,
              size: iconSize,
            ),
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
          ),
        ],
      );
    }

    // الحالة المدمجة: زر واحد بتبديل أيقونات
    return InkWell(
      onTap: widget.onCopyPressed,
      onLongPress: _handleLongPress,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: Icon(
            _showShareIcon ? SolarIconsOutline.share : SolarIconsOutline.copy,
            key: ValueKey<bool>(_showShareIcon),
            color: AppColors.gold,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}
