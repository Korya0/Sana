import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/app_spacing.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/asma_ul_husna/domain/entities/asma_ul_husna_entity.dart';
import 'package:sana/features/sharing/presentation/combined_share_copy_button.dart';

class AsmaUlHusnaCard extends StatefulWidget {
  const AsmaUlHusnaCard({
    required this.name,
    required this.onSharePressed,
    required this.onCopyPressed,
    super.key,
  });

  final AsmaUlHusnaEntity name;
  final AsyncCallback onSharePressed;
  final VoidCallback onCopyPressed;

  @override
  State<AsmaUlHusnaCard> createState() => _AsmaUlHusnaCardState();
}

class _AsmaUlHusnaCardState extends State<AsmaUlHusnaCard> {
  final ValueNotifier<bool> _isExpandedNotifier = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _isExpandedNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      child: AppToggleList(
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        onExpansionChanged: (expanded) => _isExpandedNotifier.value = expanded,

        title: _AsmaCardTitleWidget(
          name: widget.name,
          isExpandedNotifier: _isExpandedNotifier,
        ),
        trailing: _AsmaCardTrailingWidget(
          name: widget.name,
          onSharePressed: widget.onSharePressed,
          onCopyPressed: widget.onCopyPressed,
          isExpandedNotifier: _isExpandedNotifier,
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
      ),
    );
  }
}

class _AsmaCardTitleWidget extends StatelessWidget {
  const _AsmaCardTitleWidget({
    required this.name,
    required this.isExpandedNotifier,
  });

  final AsmaUlHusnaEntity name;
  final ValueNotifier<bool> isExpandedNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isExpandedNotifier,
      builder: (context, isExpanded, _) {
        return Row(
          children: [
            SizedBox(
              width: AppSpacing.w80.r(context),
              child: Text(
                name.name,
                style: AppTextStyles.fontQuran22W400primary(
                  context,
                ),
              ),
            ),
            const AppGap.w(AppSpacing.v8),
            Expanded(
              child: Text(
                name.meaningBrief,
                style: AppTextStyles.font12W500(context)
                    .copyWith(color: context.color.textSecondary)
                    .copyWith(height: 1.4),
                maxLines: isExpanded ? null : 2,
                overflow: isExpanded
                    ? TextOverflow.visible
                    : TextOverflow.ellipsis,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AsmaCardTrailingWidget extends StatelessWidget {
  const _AsmaCardTrailingWidget({
    required this.name,
    required this.onSharePressed,
    required this.onCopyPressed,
    required this.isExpandedNotifier,
  });

  final AsmaUlHusnaEntity name;
  final AsyncCallback onSharePressed;
  final VoidCallback onCopyPressed;
  final ValueNotifier<bool> isExpandedNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isExpandedNotifier,
      builder: (context, isExpanded, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CombinedShareCopyButton(
              onSharePressed: onSharePressed,
              onCopyPressed: onCopyPressed,
              iconSize: 16.r(context),
            ),
            const AppGap.w(AppSpacing.v4),
            AppArrowIcon(
              direction: isExpanded
                  ? AppArrowDirection.up
                  : AppArrowDirection.down,
            ),
          ],
        );
      },
    );
  }
}
