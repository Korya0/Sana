// RadioListTile's groupValue and onChanged are deprecated in newer Flutter versions in favor of RadioGroup,
// but we continue using RadioListTile to maintain maximum backward compatibility and layout styling.
// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
// FontAwesome removed
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/widgets/custom_app_divider.dart';
import 'package:sana/core/common/widgets/app_arrow_icon.dart';
import 'package:sana/core/common/widgets/app_toggle_list.dart';
import 'package:sana/core/constants/app_links.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/features/home/presentation/widgets/secret_pin_dialog.dart';
import 'package:share_plus/share_plus.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/theme/cubit/theme_cubit.dart';
import 'package:sana/core/theme/cubit/theme_state.dart';
import 'package:sana/core/common/overlays/dialog/custom_dialog.dart';

class HomeSettingsSection extends StatefulWidget {
  const HomeSettingsSection({super.key});

  @override
  State<HomeSettingsSection> createState() => _HomeSettingsSectionState();
}

class _HomeSettingsSectionState extends State<HomeSettingsSection> {
  @override
  Widget build(BuildContext context) {
    return AppToggleList(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.v8),
      title: Text(
        AppStrings.settings,
        style: AppTextStyles.font16W700White(context),
      ),
      children: [
        // 1. Preferences Section
        const _SectionHeader(title: AppStrings.preferences),
        _QuickTile(
          icon: FlutterIslamicIcons.mosque,
          title: AppStrings.prayerSettings,
          onTap: () => context.pushNamed(AppRoutes.prayerSettings),
        ),
        _QuickTile(
          icon: Icons.favorite_border_rounded,
          title: AppStrings.dailyContentFavorites,
          onTap: () => context.pushNamed(AppRoutes.dailyContentFavorites),
        ),
        _QuickTile(
          icon: switch (context.watch<ThemeCubit>().state.themeMode) {
            ThemeMode.system => Icons.brightness_auto_outlined,
            ThemeMode.light => Icons.light_mode_outlined,
            ThemeMode.dark => Icons.dark_mode_outlined,
          },
          title: AppStrings.themeModeLabel,
          subtitle: switch (context.watch<ThemeCubit>().state.themeMode) {
            ThemeMode.system => AppStrings.themeModeSystem,
            ThemeMode.light => AppStrings.themeModeLight,
            ThemeMode.dark => AppStrings.themeModeDark,
          },
          onTap: () => _showThemeDialog(context),
        ),
        const CustomAppDivider(),

        // 2. Help Section
        const _SectionHeader(title: AppStrings.shareReward),

        _QuickTile(
          icon: Icons.lightbulb_outline,
          title: AppStrings.feedbackTitle,
          onTap: () => context.pushNamed(
            AppRoutes.feedback,
          ),
        ),

        const CustomAppDivider(),

        // 3. Support & Social Section
        const _SectionHeader(title: AppStrings.personallyWithMe),
        _QuickTile(
          icon: Icons.chat_bubble_outline_rounded,
          title: AppStrings.contactPerBusiness,
          onTap: () => _launchURL(AppLinks.whatsapp),
        ),

        const CustomAppDivider(),

        // 4. Share & Rate Section
        const _SectionHeader(title: AppStrings.shareAndRate),
        // Rate App â€” hidden on web (no store to rate)
        if (!kIsWeb)
          _QuickTile(
            icon: SolarIconsOutline.heart,
            title: AppStrings.rateApp,
            onTap: () => _launchURL(AppLinks.storeLink),
          ),
        _QuickTile(
          icon: SolarIconsOutline.share,
          title: AppStrings.shareApp,
          onTap: () async {
            final shareText = kIsWeb
                ? AppStrings.shareWebAppText(AppLinks.webApp)
                : AppStrings.shareAppText(AppLinks.storeLink);

            await SharePlus.instance.share(
              ShareParams(text: shareText),
            );
          },
        ),

        const SizedBox(height: AppSpacing.v16),
        Center(
          child: Text(
            AppStrings.followAppOn,
            style: AppTextStyles.font12W400Grey(context).copyWith(
              height: 1.6,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.v12),
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
        const SizedBox(height: AppSpacing.v16),
        Center(
          child: GestureDetector(
            onDoubleTap: () async {
              await SecretPinDialog.show(
                context,
                onSuccess: () async {
                  await context.pushNamed(AppRoutes.developerDashboard);
                },
              );
            },
            child: Text(
              AppStrings.charityForMuslims,
              style: AppTextStyles.font12W400Grey(
                context,
              ).copyWith(height: 1.6),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.v12),
      ],
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showThemeDialog(BuildContext context) {
    unawaited(
      showCustomDialog<void>(
        context: context,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.v16),
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.v24,
                    vertical: AppSpacing.v8,
                  ),
                  child: Text(
                    AppStrings.themeModeLabel,
                    style: AppTextStyles.font16W700White(context),
                    textAlign: TextAlign.right,
                  ),
                ),
                const CustomAppDivider(),
                RadioListTile<ThemeMode>(
                  value: ThemeMode.system,
                  groupValue: state.themeMode,
                  title: Text(
                    AppStrings.themeModeSystem,
                    style: AppTextStyles.font14W700White(context),
                  ),
                  activeColor: context.color.primary,
                  onChanged: (mode) {
                    if (mode != null) {
                      unawaited(context.read<ThemeCubit>().setThemeMode(mode));
                      Navigator.pop(context);
                    }
                  },
                ),
                RadioListTile<ThemeMode>(
                  value: ThemeMode.light,
                  groupValue: state.themeMode,
                  title: Text(
                    AppStrings.themeModeLight,
                    style: AppTextStyles.font14W700White(context),
                  ),
                  activeColor: context.color.primary,
                  onChanged: (mode) {
                    if (mode != null) {
                      unawaited(context.read<ThemeCubit>().setThemeMode(mode));
                      Navigator.pop(context);
                    }
                  },
                ),
                RadioListTile<ThemeMode>(
                  value: ThemeMode.dark,
                  groupValue: state.themeMode,
                  title: Text(
                    AppStrings.themeModeDark,
                    style: AppTextStyles.font14W700White(context),
                  ),
                  activeColor: context.color.primary,
                  onChanged: (mode) {
                    if (mode != null) {
                      unawaited(context.read<ThemeCubit>().setThemeMode(mode));
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            );
          },
        ),
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
          top: AppSpacing.v8,
          bottom: AppSpacing.v4,
          right: AppSpacing.v12,
        ),
        child: Text(
          title,
          style: AppTextStyles.font12W700primaryDimmedLS05(context),
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
      visualDensity: VisualDensity.compact,
      leading: Icon(icon, color: context.color.textPrimary, size: 20),
      title: Text(
        title,
        style: AppTextStyles.font13W700White(context),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: AppTextStyles.font12W400Grey(context),
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
      child: Icon(icon, color: color, size: 24),
    );
  }
}


