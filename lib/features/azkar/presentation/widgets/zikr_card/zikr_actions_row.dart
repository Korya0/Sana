import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_card/zikr_counter.dart';

class ZikrActionsRow extends StatelessWidget {
  const ZikrActionsRow({
    required this.remainingCount,
    required this.progress,
    required this.isCompleted,
    super.key,
    this.onShare,
    this.onCopy,
  });

  final int remainingCount;
  final double progress;
  final bool isCompleted;
  final AsyncCallback? onShare;
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      // Share and copy
      _ShareCopyButtonWidget(onShare: onShare, onCopy: onCopy),

      // Remaining count
      Semantics(
        label: AppStrings.remainingCounterLabel,
        value: isCompleted ? AppStrings.completed : '$remainingCount',
        excludeSemantics: true,
        child: ZikrCounter(
          remainingCount: remainingCount,
          progress: progress,
          isCompleted: isCompleted,
        ),
      ),
    ],
  );
}

class _ShareCopyButtonWidget extends StatelessWidget {
  const _ShareCopyButtonWidget({this.onShare, this.onCopy});

  final AsyncCallback? onShare;
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) => Semantics(
    label: AppStrings.shareAndCopyOptions,
    button: true,
    child: Tooltip(
      message: AppStrings.shareAndCopyOptions,
      child: InkWell(
        onTap: onShare == null ? null : () => unawaited(onShare!()),
        onLongPress: onCopy,
        borderRadius: BorderRadius.circular(AppSize.circularRadius),
        child: Padding(
          padding: EdgeInsets.all(AppSize.p12),
          child: Icon(
            AppIcons.share,
            size: AppSize.icon24,
            color: context.color.iconBrand,
          ),
        ),
      ),
    ),
  );
}
