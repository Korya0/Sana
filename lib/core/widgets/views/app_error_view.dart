import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/buttons/app_primary_button.dart';
import 'package:sana/core/widgets/views/app_state_view.dart';

class AppErrorView extends StatelessWidget {
  const AppErrorView({
    required this.message,
    super.key,
    this.onRetry,
    this.fillHeight,
  });

  final String message;
  final VoidCallback? onRetry;

  /// Height floor for the centred content. Sliver callers pass the remaining
  /// sliver extent so the full-screen default does not create extra scroll.
  final double? fillHeight;

  // Builds error view
  @override
  Widget build(BuildContext context) => AppStateView(
    icon: AppIcons.error,
    iconColor: context.color.errorText,
    title: AppStrings.errorWidgetTitle,
    message: message,
    fillHeight: fillHeight,
    action: onRetry == null
        ? null
        : AppPrimaryButton(
            label: AppStrings.tryAgain,
            onPressed: onRetry,
          ),
  );
}
