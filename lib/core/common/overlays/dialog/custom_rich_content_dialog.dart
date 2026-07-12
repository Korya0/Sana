import 'package:sana/core/routing/app_navigator.dart';
import 'package:sana/core/common/common.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/services/sharing/presentation/combined_share_copy_button.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:solar_icons/solar_icons.dart';

class CustomRichContentDialog extends StatefulWidget {
  const CustomRichContentDialog({
    required this.bodyText,
    required this.backgroundIcon,
    this.title,
    this.source,
    this.onSharePressed,
    this.onCopyPressed,
    super.key,
  });

  final String bodyText;
  final String? title;
  final String? source;
  final IconData backgroundIcon;
  final VoidCallback? onSharePressed;
  final VoidCallback? onCopyPressed;

  static void show(
    BuildContext context, {
    required String bodyText,
    required IconData backgroundIcon,
    String? title,
    String? source,
    VoidCallback? onSharePressed,
    VoidCallback? onCopyPressed,
    String? routeName,
  }) {
    unawaited(
      showDialog(
        context: context,
        routeSettings: routeName != null
            ? RouteSettings(name: routeName)
            : null,
        builder: (context) => CustomRichContentDialog(
          bodyText: bodyText,
          backgroundIcon: backgroundIcon,
          title: title,
          source: source,
          onSharePressed: onSharePressed,
          onCopyPressed: onCopyPressed,
        ),
      ),
    );
  }

  @override
  State<CustomRichContentDialog> createState() =>
      _CustomRichContentDialogState();
}

class _CustomRichContentDialogState extends State<CustomRichContentDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.v16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.75,
            ),
            decoration: customAppCardDecoration(context),
            clipBehavior: Clip.hardEdge,
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Positioned(
                    right: -AppSpacing.v10.r(context),
                    bottom: -AppSpacing.v20.r(context),
                    child: Icon(
                      widget.backgroundIcon,
                      size: AppSpacing.s150.r(context),
                      color: context.color.textPrimary.withValues(alpha: 0.05),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.v24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.title != null &&
                            widget.title!.isNotEmpty) ...[
                          Text(
                            widget.title!,
                            style: AppTextStyles.font24W700(
                              context,
                            ).copyWith(color: context.color.textAccent),
                            textAlign: TextAlign.center,
                          ),
                          const AppGap.h(AppSpacing.v16),
                        ],

                        Text(
                          widget.bodyText,
                          style: AppTextStyles.font20W700(context).copyWith(
                            color: context.color.textPrimary,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                        ),

                        if (widget.source != null &&
                            widget.source!.isNotEmpty) ...[
                          const AppGap.h(AppSpacing.v24),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.v12.r(context),
                              vertical: AppSpacing.v6.r(context),
                            ),
                            decoration: BoxDecoration(
                              color: context.color.primary.withValues(
                                alpha: 0.05,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusS,
                              ),
                            ),
                            child: Text(
                              widget.source!,
                              style: AppTextStyles.font14W500(context).copyWith(
                                color: context.color.primary.withValues(
                                  alpha: 0.8,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                        const AppGap.h(AppSpacing.v32),

                        _buildActions(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    final showShare =
        widget.onSharePressed != null || widget.onCopyPressed != null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (showShare)
          SizedBox(
            width: AppSpacing.v48.r(context),
          )
        else
          const SizedBox.shrink(),

        TextButton(
          onPressed: () => AppNavigator.pop(context),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.v16,
              vertical: AppSpacing.v8,
            ),
            backgroundColor: context.color.primary.withValues(
              alpha: 0.1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusM),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                SolarIconsBold.closeCircle,
                color: context.color.primary,
                size: AppSpacing.s18.r(context),
              ),
              const AppGap.w(AppSpacing.v8),
              Text(
                AppStrings.close,
                style: AppTextStyles.font14W700(
                  context,
                ).copyWith(color: context.color.textAccent),
              ),
            ],
          ),
        ),

        if (showShare)
          CombinedShareCopyButton(
            onSharePressed: widget.onSharePressed ?? () {},
            onCopyPressed: widget.onCopyPressed ?? () {},
            iconSize: AppSpacing.s20.r(context),
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }
}
