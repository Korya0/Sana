import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/core/common/widgets/app_arrow_icon.dart';
import 'package:sana/core/constants/app_spacing.dart';

class AppToggleList extends StatefulWidget {
  const AppToggleList({
    required this.title,
    required this.children,
    this.leading,
    this.trailing,
    this.initiallyExpanded = false,
    this.backgroundColor,
    this.collapsedBackgroundColor,
    this.childrenPadding,
    this.onExpansionChanged,
    this.margin,
    super.key,
  });

  final Widget title;
  final List<Widget> children;
  final Widget? leading;
  final Widget? trailing;
  final bool initiallyExpanded;
  final Color? backgroundColor;
  final Color? collapsedBackgroundColor;
  final EdgeInsetsGeometry? childrenPadding;
  final ValueChanged<bool>? onExpansionChanged;
  final EdgeInsetsGeometry? margin;

  @override
  State<AppToggleList> createState() => _AppToggleListState();
}

class _AppToggleListState extends State<AppToggleList> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: context.color.scaffoldBackgroundColor.withValues(
            alpha: 0,
          ),
        ),
        child: ExpansionTile(
          initiallyExpanded: widget.initiallyExpanded,
          onExpansionChanged: (expanded) {
            unawaited(playVibrate());
            setState(() {
              _isExpanded = expanded;
            });
            widget.onExpansionChanged?.call(expanded);
          },
          leading: widget.leading,
          collapsedBackgroundColor:
              widget.collapsedBackgroundColor ??
              context.color.secondaryScaffoldBackgroundColor.withValues(
                alpha: 0.5,
              ),
          backgroundColor:
              widget.backgroundColor ??
              context.color.secondaryScaffoldBackgroundColor.withValues(
                alpha: 0.5,
              ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusL),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusL),
          ),
          title: widget.title,
          trailing:
              widget.trailing ??
              AppArrowIcon(
                direction: _isExpanded
                    ? AppArrowDirection.up
                    : AppArrowDirection.down,
              ),
          childrenPadding:
              widget.childrenPadding ??
              const EdgeInsets.symmetric(
                horizontal: AppSpacing.v12,
                vertical: AppSpacing.v8,
              ),
          children: widget.children,
        ),
      ),
    );
  }
}
