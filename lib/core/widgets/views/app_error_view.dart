import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/colors/app_colors_common.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/buttons/app_primary_button.dart';
import 'package:sana/core/widgets/views/app_state_view.dart';

class AppErrorView extends StatelessWidget {
  const AppErrorView({
    required this.message,
    super.key,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  // Builds error view
  @override
  Widget build(BuildContext context) => AppStateView(
    icon: AppIcons.error,
    iconColor: AppColorsCommon.errorColor,
    title: AppStrings.errorWidgetTitle,
    message: message,
    action: onRetry == null
        ? null
        : AppPrimaryButton(
            label: AppStrings.tryAgain,
            onPressed: onRetry,
          ),
  );
}
