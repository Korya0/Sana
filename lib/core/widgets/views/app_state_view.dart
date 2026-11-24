import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';

class AppStateView extends StatelessWidget {
  const AppStateView({
    required this.icon,
    required this.title,
    super.key,
    this.iconColor,
    this.message,
    this.action,
    this.fillHeight,
  });

  final IconData icon;
  final String title;
  final Color? iconColor;
  final String? message;
  final Widget? action;

  /// Height floor used to centre the content. Callers placed inside a sliver
  /// pass the remaining sliver extent; otherwise the full screen is used.
  final double? fillHeight;

  // Builds state
  @override
  Widget build(BuildContext context) {
    final viewport = MediaQuery.sizeOf(context);
    return SingleChildScrollView(
      child: ConstrainedBox(
        // Keep the content vertically centred on roomy viewports, but let long
        // error/empty strings scroll instead of overflowing the RenderFlex.
        // A full-screen height here double-counts the app bar when this view is
        // nested in a SliverFillRemaining, so sliver callers pass fillHeight.
        constraints: BoxConstraints(minHeight: fillHeight ?? viewport.height),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(AppSize.p24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Icon(
                  icon,
                  size: AppSize.icon48,
                  color: iconColor ?? context.color.iconSecondary,
                ),
                AppGap.h(AppSize.p16),

                // Title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: AppConstants.maxTwoLines,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.font16W700Primary(context),
                ),
                if (message != null) ...[
                  AppGap.h(AppSize.p8),

                  // Message
                  Text(
                    message!,
                    textAlign: TextAlign.center,
                    maxLines: AppConstants.maxTwoLines,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.font14W500Secondary(context),
                  ),
                ],
                if (action != null) ...[
                  AppGap.h(AppSize.p24),

                  // Action — capped to the padded content width (2 × p24).
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: viewport.width - AppSize.p48,
                    ),
                    child: action!,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
