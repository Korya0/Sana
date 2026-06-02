import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/services/app_update/presentation/cubit/app_update_cubit.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/core/utils/context_extension.dart';

class OptionalUpdateBanner extends StatefulWidget {
  const OptionalUpdateBanner({this.message, super.key});
  final String? message;

  @override
  State<OptionalUpdateBanner> createState() => OptionalUpdateBannerState();
}

class OptionalUpdateBannerState extends State<OptionalUpdateBanner> {
  bool _dismissed = false;

  @override
  Widget build(BuildContext context) {
    if (_dismissed) return const SizedBox.shrink();

    final displayMessage =
        (widget.message != null && widget.message!.isNotEmpty)
        ? widget.message!
        : AppStrings.appUpdateMessage;

    return Positioned(
      bottom: AppSpacing.v24,
      left: AppSpacing.v16,
      right: AppSpacing.v16,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0, 100 * (1 - value)),
            child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
          );
        },
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.v16),
            decoration: BoxDecoration(
              color: context.color.secondaryScaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(AppSpacing.radiusL),
              border: Border.all(
                color: context.color.primary.withValues(alpha: 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    displayMessage,
                    style: AppTextStyles.font14W700White(context),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.v8,
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () =>
                      context.read<AppUpdateCubit>().launchUpdateUrl(),
                  child: Text(
                    AppStrings.updateNow,
                    style: AppTextStyles.font16W700primary(context),
                  ),
                ),
                IconButton(
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(AppSpacing.v4),
                  onPressed: () => setState(() => _dismissed = true),
                  icon: Icon(
                    Icons.close,
                    size: 22.r(context),
                    color: context.color.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


