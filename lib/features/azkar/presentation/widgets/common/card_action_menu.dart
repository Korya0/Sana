import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/buttons/app_icon_button.dart';
import 'package:sana/core/widgets/buttons/app_text_button.dart';
import 'package:sana/core/widgets/dividers/app_divider.dart';

class CardActionMenu extends StatefulWidget {
  const CardActionMenu({
    required this.canAdjust,
    required this.onDecrement,
    required this.onReset,
    super.key,
    this.onEdit,
    this.onDelete,
    this.editLabel,
    this.deleteLabel,
    this.showCountActions = true,
  });

  final bool canAdjust;
  final VoidCallback onDecrement;
  final VoidCallback onReset;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final String? editLabel;
  final String? deleteLabel;
  final bool showCountActions;

  @override
  State<CardActionMenu> createState() => _CardActionMenuState();
}

class _CardActionMenuState extends State<CardActionMenu> {
  final GlobalKey _minusKey = GlobalKey();
  final GlobalKey _infoKey = GlobalKey();
  OverlayEntry? _entry;
  double _menuLeft = 0;
  double _menuTop = 0;
  bool _showCountActions = false;
  bool _showItemActions = false;

  bool get _hasItemActions =>
      widget.onEdit != null || widget.onDelete != null;

  void _openMenu({required bool fromInfo}) {
    _closeMenu();
    final key = fromInfo && _hasItemActions ? _infoKey : _minusKey;
    final iconContext = key.currentContext;
    if (iconContext == null) return;
    final box = iconContext.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero);
    final screen = MediaQuery.sizeOf(context);
    final menuWidth = AppSize.w88 * 2;
    final menuHeight = AppSize.h135;
    final gap = AppSize.p4;
    final iconLeft = offset.dx;
    final iconRight = offset.dx + box.size.width;
    final iconTop = offset.dy;
    final iconBottom = offset.dy + box.size.height;

    final candidates = <Offset>[
      Offset(iconLeft - menuWidth - gap, iconBottom + gap),
      Offset(iconRight + gap, iconBottom + gap),
      Offset(iconLeft - menuWidth - gap, iconTop - menuHeight - gap),
      Offset(iconRight + gap, iconTop - menuHeight - gap),
    ];
    final chosen = candidates.firstWhere(
      (point) =>
          point.dx >= 0 &&
          point.dx + menuWidth <= screen.width &&
          point.dy >= 0 &&
          point.dy + menuHeight <= screen.height,
      orElse: () => Offset(
        (screen.width - menuWidth) / 2,
        (iconBottom + gap).clamp(0.0, screen.height - menuHeight),
      ),
    );
    _menuLeft = chosen.dx;
    _menuTop = chosen.dy;

    _showCountActions = !fromInfo;
    _showItemActions = fromInfo;

    _entry = OverlayEntry(
      builder: (context) => Material(
        color: Colors.transparent,
        child: Builder(
          builder: (context) => Stack(
            children: [
              // Tap outside closes the menu.
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _closeMenu,
                ),
              ),
              Positioned(
                left: _menuLeft,
                top: _menuTop,
                child: _buildOverlay(context),
              ),
            ],
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_entry!);
  }

  void _closeMenu() {
    _entry?.remove();
    _entry = null;
    if (!mounted) return;
    setState(() {
      _showCountActions = false;
      _showItemActions = false;
    });
  }

  void _run(VoidCallback action) {
    _closeMenu();
    action();
  }

  @override
  void dispose() {
    _entry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      // Minus inside a circle (single icon, no overlaid decoration).
      if (widget.showCountActions)
        AppIconButton(
          key: _minusKey,
          icon: AppIcons.minus,
          size: AppSize.icon24,
          tooltip: AppStrings.decrementOne,
          onPressed: widget.canAdjust ? () => _openMenu(fromInfo: false) : null,
        ),
      if (_hasItemActions)
        AppIconButton(
          key: _infoKey,
          icon: AppIcons.info,
          size: AppSize.icon24,
          tooltip: AppStrings.azkarHomeOptions,
          onPressed: () => _openMenu(fromInfo: true),
        ),
    ],
  );

  Widget _buildOverlay(BuildContext context) => Container(
    width: AppSize.w88 * 2,
    padding: EdgeInsets.all(AppSize.p8),
    decoration: BoxDecoration(
      color: context.color.secondaryScaffoldBackgroundColor,
      borderRadius: BorderRadius.circular(AppSize.r12),
      border: Border.all(
        color: context.color.dividerColor,
        width: AppSize.borderWidth,
      ),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_showCountActions) ...[
          AppTextButton(
            key: const ValueKey('count_decrement_action'),
            icon: AppIcons.minus,
            label: AppStrings.decrementOne,
            expand: true,
            onPressed: () => _run(widget.onDecrement),
          ),
          const AppDivider(),
          AppTextButton(
            key: const ValueKey('count_reset_action'),
            icon: AppIcons.refresh,
            label: AppStrings.resetCounter,
            expand: true,
            textStyle: AppTextStyles.font14W700Error(context),
            onPressed: () => _run(widget.onReset),
          ),
        ],
        if (_showItemActions) ...[
          if (widget.onEdit != null && widget.editLabel != null)
            AppTextButton(
              icon: AppIcons.edit,
              label: widget.editLabel!,
              expand: true,
              onPressed: () => _run(widget.onEdit!),
            ),
          if (widget.onEdit != null &&
              widget.editLabel != null &&
              widget.onDelete != null &&
              widget.deleteLabel != null)
            const AppDivider(),
          if (widget.onDelete != null && widget.deleteLabel != null)
            AppTextButton(
              icon: AppIcons.close,
              label: widget.deleteLabel!,
              expand: true,
              textStyle: AppTextStyles.font14W700Error(context),
              onPressed: () => _run(widget.onDelete!),
            ),
        ],
      ],
    ),
  );
}
