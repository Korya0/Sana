import 'package:flutter/material.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/services/sharing/presentation/combined_share_copy_button.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/asma_ul_husna/domain/entities/asma_ul_husna_entity.dart';

class AsmaUlHusnaCard extends StatefulWidget {
  const AsmaUlHusnaCard({
    required this.name,
    required this.onSharePressed,
    required this.onCopyPressed,
    super.key,
  });

  final AsmaUlHusnaEntity name;
  final VoidCallback onSharePressed;
  final VoidCallback onCopyPressed;

  @override
  State<AsmaUlHusnaCard> createState() => _AsmaUlHusnaCardState();
}

class _AsmaUlHusnaCardState extends State<AsmaUlHusnaCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AppToggleList(
      onExpansionChanged: (expanded) => setState(() => _isExpanded = expanded),

      title: Row(
        children: [
          SizedBox(
            width: AppSpacing.w80.r(context),
            child: Text(
              widget.name.name,
              style: AppTextStyles.fontQuran22W400primary(
                context,
              ),
            ),
          ),
          const AppGap.w(AppSpacing.v8),
          Expanded(
            child: Text(
              widget.name.meaningBrief,
              style: AppTextStyles.font12W500(context)
                  .copyWith(color: context.color.textSecondary)
                  .copyWith(height: 1.4),
              maxLines: _isExpanded ? null : 2,
              overflow: _isExpanded
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CombinedShareCopyButton(
            onSharePressed: widget.onSharePressed,
            onCopyPressed: widget.onCopyPressed,
            iconSize: 16.r(context),
          ),
          const AppGap.w(AppSpacing.v4),
          AppArrowIcon(
            direction: _isExpanded
                ? AppArrowDirection.up
                : AppArrowDirection.down,
          ),
        ],
      ),
      children: [
        const CustomAppDivider(),
        const AppGap.h(AppSpacing.v16),
        Text(
          widget.name.meaningDetailed,
          style: AppTextStyles.font14W500(
            context,
          ).copyWith(color: context.color.textSecondary, height: 1.6),
          textAlign: TextAlign.justify,
          textDirection: TextDirection.rtl,
        ),
        const AppGap.h(AppSpacing.v8),
      ],
    );
  }
}
