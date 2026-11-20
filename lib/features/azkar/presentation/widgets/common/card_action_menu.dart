import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/buttons/app_icon_button.dart';
import 'package:sana/core/widgets/buttons/app_text_button.dart';
import 'package:sana/core/widgets/dividers/app_divider.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';

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
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final menuWidth = AppSize.w88 * 2;
    final menuHeight = AppSize.h150;
    final gap = AppSize.p4;
    final screenMargin = AppSize.p8;
    final iconLeft = offset.dx;
    final iconRight = offset.dx + box.size.width;
    final iconTop = offset.dy;
    final iconBottom = offset.dy + box.size.height;

    // Corner candidates
    final bottomRight = Offset(iconRight - menuWidth, iconBottom + gap);
    final bottomLeft = Offset(iconLeft, iconBottom + gap);
    final topRight = Offset(iconRight - menuWidth, iconTop - menuHeight - gap);
    final topLeft = Offset(iconLeft, iconTop - menuHeight - gap);

    // Screen bounds check
    final bool fitsBelow =
        iconBottom + gap + menuHeight <= screen.height - screenMargin;
    final bool fitsAbove = iconTop - gap - menuHeight >= screenMargin;

    // Preferred expansion
    final bool preferLeftExpansion = isRtl
        ? (iconRight - menuWidth >= screenMargin)
        : (iconLeft + menuWidth > screen.width - screenMargin);

    final List<Offset> candidates;
    if (fitsBelow || !fitsAbove) {
      candidates = preferLeftExpansion
          ? [bottomRight, bottomLeft, topRight, topLeft]
          : [bottomLeft, bottomRight, topLeft, topRight];
    } else {
      candidates = preferLeftExpansion
          ? [topRight, topLeft, bottomRight, bottomLeft]
          : [topLeft, topRight, bottomLeft, bottomRight];
    }

    final chosen = candidates.firstWhere(
      (point) =>
          point.dx >= screenMargin &&
          point.dx + menuWidth <= screen.width - screenMargin &&
          point.dy >= screenMargin &&
          point.dy + menuHeight <= screen.height - screenMargin,
      orElse: () {
        // Clamp fallback
        final double fallbackX = preferLeftExpansion
            ? (iconRight - menuWidth).clamp(
                screenMargin,
                (screen.width - menuWidth - screenMargin)
                    .clamp(screenMargin, double.infinity),
              )
            : iconLeft.clamp(
                screenMargin,
                (screen.width - menuWidth - screenMargin)
                    .clamp(screenMargin, double.infinity),
              );

        final double fallbackY =
            (fitsBelow || iconTop < screen.height - iconBottom)
                ? (iconBottom + gap).clamp(
                    screenMargin,
                    (screen.height - menuHeight - screenMargin)
                        .clamp(screenMargin, double.infinity),
                  )
                : (iconTop - menuHeight - gap).clamp(
                    screenMargin,
                    (screen.height - menuHeight - screenMargin)
                        .clamp(screenMargin, double.infinity),
                  );

        return Offset(fallbackX, fallbackY);
      },
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
              // Tap outside
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _closeMenu,
                ),
              ),
              Positioned(
                left: _menuLeft,
                top: _menuTop,
                child: _CardActionMenuOverlayWidget(
                  showCountActions: _showCountActions,
                  showItemActions: _showItemActions,
                  onDecrement: () => _run(widget.onDecrement),
                  onReset: () => _run(widget.onReset),
                  onClose: _closeMenu,
                  onEdit: widget.onEdit != null ? () => _run(widget.onEdit!) : null,
                  onDelete: widget.onDelete != null ? () => _run(widget.onDelete!) : null,
                  editLabel: widget.editLabel,
                  deleteLabel: widget.deleteLabel,
                ),
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
}

class _CardActionMenuOverlayWidget extends StatelessWidget {
  const _CardActionMenuOverlayWidget({
    required this.showCountActions,
    required this.showItemActions,
    required this.onDecrement,
    required this.onReset,
    required this.onClose,
    this.onEdit,
    this.onDelete,
    this.editLabel,
    this.deleteLabel,
  });

  final bool showCountActions;
  final bool showItemActions;
  final VoidCallback onDecrement;
  final VoidCallback onReset;
  final VoidCallback onClose;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final String? editLabel;
  final String? deleteLabel;

  @override
  Widget build(BuildContext context) => Stack(
    clipBehavior: Clip.none,
    children: [
      // Menu container
      Container(
        width: AppSize.w88 * 2,
        padding: EdgeInsets.only(
          left: AppSize.p8,
          right: AppSize.p8,
          bottom: AppSize.p8,
          top: AppSize.p16,
        ),
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showCountActions) ...[
              AppTextButton(
                key: const ValueKey('count_decrement_action'),
                icon: AppIcons.minus,
                label: AppStrings.decrementOne,
                expand: true,
                onPressed: onDecrement,
              ),
              const AppDivider(),
              AppTextButton(
                key: const ValueKey('count_reset_action'),
                icon: AppIcons.refresh,
                label: AppStrings.resetCounter,
                expand: true,
                textStyle: AppTextStyles.font14W700Error(context),
                onPressed: onReset,
              ),
            ],
            if (showItemActions) ...[
              if (onEdit != null && editLabel != null)
                AppTextButton(
                  icon: AppIcons.edit,
                  label: editLabel!,
                  expand: true,
                  onPressed: onEdit,
                ),
              if (onEdit != null &&
                  editLabel != null &&
                  onDelete != null &&
                  deleteLabel != null)
                const AppDivider(),
              if (onDelete != null && deleteLabel != null)
                AppTextButton(
                  icon: AppIcons.close,
                  label: deleteLabel!,
                  expand: true,
                  textStyle: AppTextStyles.font14W700Error(context),
                  onPressed: onDelete,
                ),
            ],
          ],
        ),
      ),

      // Close button
      Positioned(
        top: -AppSize.p8,
        right: -AppSize.p8,
        child: Tooltip(
          message: AppStrings.close,
          excludeFromSemantics: true,
          child: AppPressable(
            key: const ValueKey('card_action_menu_close_button'),
            onPressed: onClose,
            semanticLabel: AppStrings.close,
            child: Container(
              width: AppSize.w24,
              height: AppSize.w24,
              decoration: BoxDecoration(
                color: context.color.secondaryScaffoldBackgroundColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.color.dividerColor,
                  width: AppSize.borderWidth,
                ),
              ),
              child: Center(
                child: Icon(
                  AppIcons.close,
                  size: AppSize.icon16,
                  color: context.color.iconNeutral,
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
