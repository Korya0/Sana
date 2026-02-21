import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/widgets/app_buttons.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/app_update/presentation/controller/app_update_cubit.dart';
import 'package:sana/features/app_update/presentation/widgets/update_icon.dart';

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
          color: AppColors.scaffoldBackground.withValues(alpha: 0.8),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const UpdateIcon(),
                  const SizedBox(height: 24),
                  Text(
                    'تحديث جديد متاح',
                    style: AppTextStyles.font22W700Gold(context),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    message.isNotEmpty
                        ? message
                        : 'يجب تحديث التطبيق للمتابعة والحصول على أحدث المميزات والتحسينات.',
                    style: AppTextStyles.font16W500Whit(context).copyWith(
                      color: AppColors.white.withValues(alpha: 0.7),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  AppSecondaryButton(
                    text: 'تحديث الآن',
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
