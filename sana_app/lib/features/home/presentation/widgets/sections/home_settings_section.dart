import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
// FontAwesome removed
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/decorations/custom_app_divider.dart';
import 'package:sana/core/common/widgets/app_arrow_icon.dart';
import 'package:sana/core/common/widgets/app_toggle_list.dart';
import 'package:sana/core/constants/app_links.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/features/home/presentation/widgets/secret_pin_dialog.dart';
import 'package:share_plus/share_plus.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:url_launcher/url_launcher.dart';

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
        style: AppTextStyles.font16W600White(context),
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
        // Rate App — hidden on web (no store to rate)
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
              color: AppColors.facebookBlue,
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
          style: AppTextStyles.font12W600primaryDimmedLS05(context),
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
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      dense: true,
      visualDensity: VisualDensity.compact,
      leading: Icon(icon, color: AppColors.iconWhite, size: 20),
      title: Text(
        title,
        style: AppTextStyles.font13W600White(context),
      ),
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
