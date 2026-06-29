import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/buttons/app_buttons.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/services/app_update/presentation/cubit/app_update_cubit.dart';
import 'package:sana/core/services/app_update/presentation/widgets/update_icon.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_spacing.dart';

class ForceUpdateOverlay extends StatelessWidget {
  const ForceUpdateOverlay({required this.message, super.key});
  final String message;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Material(
          color: context.color.scaffoldBackgroundColor.withValues(alpha: 0.8),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.v32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const UpdateIcon(),
                  const SizedBox(height: AppSpacing.v24),
                  Text(
                    message.isNotEmpty ? message : AppStrings.appUpdateMessage,
                    style: AppTextStyles.font16W500(context).copyWith(color: context.color.textSecondary).copyWith(
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.v32),
                  AppSecondaryButton(
                    text: AppStrings.updateNow,
                    onPressed: () =>
                        context.read<AppUpdateCubit>().launchUpdateUrl(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
