import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/common/decorations/custom_app_divider.dart';
import 'package:sana/core/common/decorations/feature_card_decoration.dart';
import 'package:sana/core/common/widgets/app_arrow_icon.dart';
import 'package:sana/core/common/widgets/app_toggle_list.dart';
import 'package:sana/core/services/sharing/logic/widget_to_image.dart';
import 'package:sana/core/services/sharing/presentation/combined_share_copy_button.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/core/utils/context_extension.dart';
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
    await WidgetToImage.shareWidget(
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
    return Container(
      decoration: featureCardDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusL.r(context)),
        borderColor: _isExpanded
            ? AppColors.primary.withValues(alpha: 0.3)
            : AppColors.primary.withValues(alpha: 0.1),
      ),
      child: AppToggleList(
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        onExpansionChanged: (expanded) => setState(() => _isExpanded = expanded),
        leading: Container(
          width: 32.r(context),
          height: 32.r(context),
          decoration: BoxDecoration(
            color: AppColors.scaffoldBackground,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.5),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            '${widget.name.id}',
            style: AppTextStyles.font16W500Grey(context),
          ),
        ),
        title: Row(
          children: [
            Text(
              widget.name.name,
              style: AppTextStyles.font26W700primaryQuran(context),
            ),
            const SizedBox(width: AppSpacing.v8),
            Expanded(
              child: Text(
                widget.name.meaningBrief,
                style: AppTextStyles.font14W500Grey(context).copyWith(height: 1.4),
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
              iconSize: 22.r(context),
            ),
            const SizedBox(width: AppSpacing.v4),
            AppArrowIcon(
              direction:
                  _isExpanded ? AppArrowDirection.up : AppArrowDirection.down,
            ),
          ],
        ),
        children: [
          const CustomAppDivider(),
          const SizedBox(height: AppSpacing.v16),
          Text(
            widget.name.meaningDetailed,
            style: AppTextStyles.font14W400Grey(context).copyWith(height: 1.6),
            textAlign: TextAlign.justify,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: AppSpacing.v8),
        ],
      ),
    );
  }
}
