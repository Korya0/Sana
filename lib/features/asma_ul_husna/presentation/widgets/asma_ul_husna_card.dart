import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/services/sharing/presentation/utils/widget_to_image_helper.dart';
import 'package:sana/core/services/sharing/presentation/combined_share_copy_button.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/asma_ul_husna/data/models/asmaul_husna_model.dart';
import 'package:sana/features/asma_ul_husna/presentation/widgets/share_card/asma_ul_husna_share_card.dart';

class AsmaUlHusnaCard extends StatefulWidget {
  const AsmaUlHusnaCard({required this.name, super.key});
  final AsmaulHusnaModel name;

  @override
  State<AsmaUlHusnaCard> createState() => _AsmaUlHusnaCardState();
}

class _AsmaUlHusnaCardState extends State<AsmaUlHusnaCard> {
  bool _isExpanded = false;

  Future<void> _shareCard() async {
    await WidgetToImageHelper.shareWidget(
      context: context,
      widget: AsmaUlHusnaShareCard(name: widget.name),
      imageName: 'share_asma_${widget.name.id}',
    );
  }

  Future<void> _copyToClipboard() async {
    final textToCopy =
        '${widget.name.name}\n${widget.name.meaningBrief}\n\n${widget.name.meaningDetailed}';
    await Clipboard.setData(ClipboardData(text: textToCopy));
  }

  @override
  Widget build(BuildContext context) {
    return AppToggleList(
      onExpansionChanged: (expanded) => setState(() => _isExpanded = expanded),

      title: Row(
        children: [
          SizedBox(
            width: 80.r(context),
            child: Text(
              widget.name.name,
              style: AppTextStyles.fontQuran22W400primary(
                context,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.v8),
          Expanded(
            child: Text(
              widget.name.meaningBrief,
              style: AppTextStyles.font12W500(context)
                  .copyWith(color: context.color.textSecondary)
                  .copyWith(height: 1.4),
              maxLines: _isExpanded ? null : 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CombinedShareCopyButton(
            onSharePressed: _shareCard,
            onCopyPressed: _copyToClipboard,
            iconSize: 16.r(context),
          ),
          const SizedBox(width: AppSpacing.v4),
          AppArrowIcon(
            direction: _isExpanded
                ? AppArrowDirection.up
                : AppArrowDirection.down,
          ),
        ],
      ),
      children: [
        const CustomAppDivider(),
        const SizedBox(height: AppSpacing.v16),
        Text(
          widget.name.meaningDetailed,
          style: AppTextStyles.font14W500(
            context,
          ).copyWith(color: context.color.textSecondary, height: 1.6),
          textAlign: TextAlign.justify,
          textDirection: TextDirection.rtl,
        ),
        const SizedBox(height: AppSpacing.v8),
      ],
    );
  }
}
