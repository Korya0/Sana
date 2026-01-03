// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sana/core/common/widgets/app_buttons.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/services/force_update/force_update_cubit.dart';
import 'package:sana/core/services/force_update/force_update_state.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpdateController extends StatelessWidget {
  final Widget child;

  const ForceUpdateController({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<ForceUpdateCubit>()..initialize(),
      child: Stack(children: [child, const _UpdateOverlay()]),
    );
  }
}

class _UpdateOverlay extends StatefulWidget {
  const _UpdateOverlay();

  @override
  State<_UpdateOverlay> createState() => _UpdateOverlayState();
}

class _UpdateOverlayState extends State<_UpdateOverlay> {
  bool _bannerDismissed = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForceUpdateCubit, ForceUpdateState>(
      builder: (context, state) {
        if (!state.isUpdateRequired || state.config == null) {
          return const SizedBox.shrink();
        }

        final config = state.config!;
        final bool forceStop = config.forceStop;
        final bool showBanner = config.showBanner;

        // Force Stop UI
        if (forceStop) {
          return PopScope(
            canPop: false,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Material(
                color: AppColors.scaffoldBackground.withOpacity(0.8),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.system_update_rounded,
                            color: AppColors.gold,
                            size: 64,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'تحديث جديد متاح',
                          style: AppTextStyles.font22W700Gold(context),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          config.message.isNotEmpty
                              ? config.message
                              : 'يجب تحديث التطبيق للمتابعة والحصول على أحدث المميزات والتحسينات.',
                          style: AppTextStyles.font16W500Whit(context).copyWith(
                            color: AppColors.white.withOpacity(0.7),
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        AppSecondaryButton(
                          text: 'تحديث الآن',
                          onPressed: _launchURL,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        // Optional Banner UI
        if (showBanner && !_bannerDismissed) {
          return Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
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
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.gold.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: AppColors.gold),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'تحديث جديد متوفر',
                          style: AppTextStyles.font14W600White(context),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: _launchURL,
                        child: Text(
                          'تحديث',
                          style: AppTextStyles.font16W600Gold(context),
                        ),
                      ),
                      IconButton(
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(4),
                        onPressed: () =>
                            setState(() => _bannerDismissed = true),
                        icon: const Icon(
                          Icons.close,
                          size: 22,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Future<void> _launchURL() async {
    final url = Uri.parse(AppConstants.playStoreUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
