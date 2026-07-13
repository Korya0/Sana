import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/cubit/app_cubit.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/routing/app_navigator.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/core/common/overlays/dialog/secret_pin_dialog.dart';
import 'package:sana/core/services/sharing/logic/i_share_service.dart';
import 'package:sana/core/services/url_launcher/i_launch_url_service.dart';
import 'package:sana/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:sana/features/settings/presentation/cubit/settings_state.dart';
import 'package:solar_icons/solar_icons.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SettingsCubit>(),
      child: Scaffold(
        body: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            const CommonSliverAppBar(
              title: AppStrings.settings,
              hasBackButton: false,
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.v16),
              sliver: BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, state) {
                  return SliverList(
                    delegate: SliverChildListDelegate([
                      // 1. Preferences Section
                      const _SectionHeader(title: AppStrings.preferences),
                      _QuickTile(
                        icon: FlutterIslamicIcons.mosque,
                        title: AppStrings.prayerSettings,
                        onTap: () =>
                            AppNavigator.pushNamed(context, AppRoutes.prayerSettings),
                      ),

                      _QuickTile(
                        icon: switch (context
                            .watch<AppCubit>()
                            .state
                            .themeMode) {
                          ThemeMode.system => Icons.brightness_auto,
                          ThemeMode.light => Icons.light_mode,
                          ThemeMode.dark => Icons.dark_mode,
                        },
                        title: AppStrings.themeModeLabel,
                        subtitle: switch (context
                            .watch<AppCubit>()
                            .state
                            .themeMode) {
                          ThemeMode.system => AppStrings.themeModeSystem,
                          ThemeMode.light => AppStrings.themeModeLight,
                          ThemeMode.dark => AppStrings.themeModeDark,
                        },
                        onTap: () => _showThemeBottomSheet(context),
                      ),

                      Semantics(
                        label: AppStrings.keepScreenAwakeTitle,
                        value: context
                                .watch<AppCubit>()
                                .state
                                .keepScreenAwake
                            ? AppStrings.enabled
                            : AppStrings.disabled,
                        hint: AppStrings.doubleTapToToggle,
                        excludeSemantics: true,
                        child: SwitchListTile.adaptive(
                          secondary: Icon(
                            Icons.screen_lock_portrait_outlined,
                            color: context.color.textPrimary,
                            size: AppSpacing.s24.r(context),
                          ),
                          title: Text(
                            AppStrings.keepScreenAwakeTitle,
                            style: AppTextStyles.font14W700(context).copyWith(
                              color: context.color.textPrimary,
                            ),
                          ),
                          subtitle: Text(
                            AppStrings.keepScreenAwakeDescription,
                            style: AppTextStyles.font12W500(context).copyWith(
                              color: context.color.textSecondary,
                            ),
                          ),
                          value: context
                              .watch<AppCubit>()
                              .state
                              .keepScreenAwake,
                          activeTrackColor:
                              context.color.primary.withValues(alpha: 0.5),
                          activeThumbColor: context.color.primary,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (_) => unawaited(
                            context
                                .read<AppCubit>()
                                .toggleKeepScreenAwake(),
                          ),
                        ),
                      ),

                      // 2. Support Section
                      const _SectionHeader(title: AppStrings.support),

                      _QuickTile(
                        icon: Icons.lightbulb,
                        title: AppStrings.feedbackTitle,
                        onTap: () => AppNavigator.pushNamed(context, AppRoutes.feedback),
                      ),
                      _QuickTile(
                        icon: Icons.chat_bubble_rounded,
                        title: AppStrings.contactPerBusiness,
                        onTap: () => _launchURL(AppLinks.whatsapp),
                      ),

                      // 3. About App Section
                      const _SectionHeader(title: AppStrings.aboutApp),
                      if (state.isRatingSupported)
                        _QuickTile(
                          icon: SolarIconsOutline.heart,
                          title: AppStrings.rateApp,
                          onTap: () => _launchURL(AppLinks.storeLink),
                        ),
                      _QuickTile(
                        icon: SolarIconsOutline.share,
                        title: AppStrings.shareApp,
                        onTap: () async {
                          await sl<IShareService>().shareText(state.shareText);
                        },
                      ),

                      const AppGap.h(AppSpacing.v32),
                      Center(
                        child: Text(
                          AppStrings.followAppOn,
                          style: AppTextStyles.font12W500(context)
                              .copyWith(color: context.color.textSecondary)
                              .copyWith(
                                height: 1.6,
                              ),
                        ),
                      ),
                      const AppGap.h(AppSpacing.v12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _SocialIcon(
                            icon: Icons.facebook,
                            color: const Color(0xFF1877F2),
                            onTap: () => _launchURL(AppLinks.facebook),
                          ),
                        ],
                      ),
                      const AppGap.h(AppSpacing.v16),
                      Center(
                        child: GestureDetector(
                          onDoubleTap: () async {
                            await SecretPinDialog.show(
                              context,
                              onSuccess: () async {
                                await AppNavigator.pushNamed(context, 
                                  AppRoutes.developerDashboard,
                                );
                              },
                            );
                          },
                          child: Text(
                            AppStrings.charityForMuslims,
                            style: AppTextStyles.font12W500(context)
                                .copyWith(color: context.color.textSecondary)
                                .copyWith(height: 1.6),
                          ),
                        ),
                      ),
                      const AppGap.h(AppSpacing.v32),
                    ]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    await sl<ILaunchUrlService>().launch(url);
  }

  void _showThemeBottomSheet(BuildContext context) {
    unawaited(
      showCustomBottomSheet(
        context,
        child: const ThemeModeSelectorBottomSheet(),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(
          top: AppSpacing.v16,
          bottom: AppSpacing.v8,
          right: AppSpacing.v12,
        ),
        child: Text(
          title,
          style: AppTextStyles.font12W700(context).copyWith(
            color: context.color.textAccent.withValues(alpha: 0.85),
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

class _QuickTile extends StatelessWidget {
  const _QuickTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      dense: true,
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      leading: Icon(icon, color: context.color.textPrimary, size: AppSpacing.s24.r(context)),
      title: Text(
        title,
        style: AppTextStyles.font14W700(
          context,
        ).copyWith(color: context.color.textPrimary),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: AppTextStyles.font12W500(
                context,
              ).copyWith(color: context.color.textSecondary),
            )
          : null,
      trailing: const AppArrowIcon(),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  const _SocialIcon({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Icon(icon, color: color, size: AppSpacing.s28.r(context)),
    );
  }
}
