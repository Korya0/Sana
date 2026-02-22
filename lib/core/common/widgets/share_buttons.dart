import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:solar_icons/solar_icons.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({super.key, this.onSharePressed, this.iconSize});
  final VoidCallback? onSharePressed;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onSharePressed,
      icon: Icon(
        SolarIconsOutline.share,
        color: AppColors.grey,
        size: iconSize ?? 20,
      ),
    );
  }
}

class CopyButton extends StatelessWidget {
  const CopyButton({super.key, this.onCopyPressed, this.iconSize});
  final VoidCallback? onCopyPressed;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onCopyPressed,
      icon: Icon(
        SolarIconsOutline.copy,
        color: AppColors.grey,
        size: iconSize ?? 20,
      ),
    );
  }
}

class CombinedShareCopyButton extends StatefulWidget {
  const CombinedShareCopyButton({
    required this.onSharePressed,
    required this.onCopyPressed,
    super.key,
    this.iconSize,
  });

  final VoidCallback onSharePressed;
  final VoidCallback onCopyPressed;
  final double? iconSize;

  @override
  State<CombinedShareCopyButton> createState() =>
      _CombinedShareCopyButtonState();
}

class _CombinedShareCopyButtonState extends State<CombinedShareCopyButton> {
  bool _showCopyIcon = false;

  void _handleLongPress() {
    widget.onCopyPressed();
    setState(() {
      _showCopyIcon = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showCopyIcon = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onSharePressed,
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
            _showCopyIcon ? SolarIconsOutline.copy : SolarIconsOutline.share,
            key: ValueKey<bool>(_showCopyIcon),
            color: _showCopyIcon ? AppColors.gold : AppColors.grey,
            size: widget.iconSize ?? 22,
          ),
        ),
      ),
    );
  }
}
