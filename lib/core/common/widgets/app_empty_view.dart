import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:solar_icons/solar_icons.dart';

/// A generic empty state view used when no data is available.
class AppEmptyView extends StatelessWidget {
  const AppEmptyView({
    super.key,
    this.message = AppStrings.noDataAvailable,
    this.icon = SolarIconsBold.boxMinimalistic,
  });

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.v24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64.r(context),
              color: Theme.of(context).disabledColor.withValues(alpha: 0.3),
            ),
            const SizedBox(height: AppSpacing.v16),
            Text(
              message,
              style: AppTextStyles.font16W500Grey(context),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
