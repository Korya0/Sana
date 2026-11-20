import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/dividers/app_divider.dart';

class AppSheetBody extends StatelessWidget {
  const AppSheetBody({
    required this.children,
    super.key,
    this.dividerPadding,
    this.padding,
    this.maxHeight,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry? dividerPadding;
  final EdgeInsetsGeometry? padding;
  final double? maxHeight;

  @override
  Widget build(BuildContext context) => Container(
    padding: padding ?? EdgeInsets.all(AppSize.p12),
    decoration: BoxDecoration(
      color: context.color.scaffoldBackgroundColor,
      borderRadius: BorderRadius.circular(AppSize.r16),
    ),
    child: _buildContent(),
  );

  Widget _buildContent() {
    final column = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _buildRows(children),
    );
    if (maxHeight == null) return column;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight!),
      child: SingleChildScrollView(child: column),
    );
  }

  // Gaps are spacing, not rows: dividers separate real content rows only.
  List<Widget> _buildRows(List<Widget> children) {
    final rows = <Widget>[];
    var hasRow = false;
    for (final child in children) {
      if (child is AppGap) {
        rows.add(child);
        continue;
      }
      if (hasRow) {
        rows.add(
          Padding(
            padding: dividerPadding ??
                EdgeInsets.symmetric(vertical: AppSize.p8),
            child: const AppDivider(),
          ),
        );
      }
      rows.add(child);
      hasRow = true;
    }
    return rows;
  }
}
