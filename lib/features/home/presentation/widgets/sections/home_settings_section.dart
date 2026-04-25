import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
// FontAwesome removed
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_links.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/features/home/presentation/widgets/secret_pin_dialog.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sana/core/common/widgets/app_arrow_icon.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeSettingsSection extends StatefulWidget {
  const HomeSettingsSection({super.key});

  @override
  State<HomeSettingsSection> createState() => _HomeSettingsSectionState();
}

class _HomeSettingsSectionState extends State<HomeSettingsSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.v8),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          onExpansionChanged: (expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },
          collapsedBackgroundColor: AppColors.secondaryBackground.withValues(
            alpha: 0.5,
          ),
          backgroundColor: AppColors.secondaryBackground.withValues(alpha: 0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusL),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusL),
          ),
          title: Text(
            AppStrings.settings,
            style: AppTextStyles.font16W600White(context),
          ),
          trailing: AppArrowIcon(
            direction: _isExpanded ? AppArrowDirection.up : AppArrowDirection.down,
          ),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.v12,
            vertical: AppSpacing.v8,
          ),
          children: [
            // 1. Preferences Section
            _buildSectionHeader(context, AppStrings.preferences),
            _buildQuickTile(
              context,
              icon: FlutterIslamicIcons.mosque,
              title: AppStrings.prayerSettings,
              onTap: () => context.pushNamed(AppRoutes.prayerSettings),
            ),
            _buildQuickTile(
              context,
              icon: Icons.favorite_border_rounded,
              title: AppStrings.dailyContentFavorites,
              onTap: () => context.pushNamed(AppRoutes.dailyContentFavorites),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.v12),
              child: Divider(
                color: AppColors.grey,
                thickness: 0.1,
                height: AppSpacing.v16,
              ),
            ),

            // 2. Help Section
            _buildSectionHeader(context, AppStrings.shareReward),

            _buildQuickTile(
              context,
              icon: Icons.lightbulb_outline,
              title: AppStrings.feedbackTitle,
              onTap: () => context.pushNamed(
                AppRoutes.feedback,
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.v12),
              child: Divider(
                color: AppColors.grey,
                thickness: 0.1,
                height: AppSpacing.v16,
              ),
            ),

            // 3. Support & Social Section
            _buildSectionHeader(context, AppStrings.personallyWithMe),
            _buildQuickTile(
              context,
              icon: Icons.chat_bubble_outline_rounded,
              title: AppStrings.contactPerBusiness,
              onTap: () => _launchURL(AppLinks.whatsapp),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.v12),
              child: Divider(
                color: AppColors.grey,
                thickness: 0.1,
                height: AppSpacing.v16,
              ),
            ),

            // 4. Share & Rate Section
            _buildSectionHeader(context, AppStrings.shareAndRate),
            // Rate App — hidden on web (no store to rate)
            if (!kIsWeb)
              _buildQuickTile(
                context,
                icon: SolarIconsOutline.heart,
                title: AppStrings.rateApp,
                onTap: () => _launchURL(AppLinks.storeLink),
              ),
            _buildQuickTile(
              context,
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
                _buildSocialIcon(
                  Icons.facebook,
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
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
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

  Widget _buildQuickTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return ListTile(
      onTap: onTap,
      dense: true,
      visualDensity: VisualDensity.compact,
      leading: Icon(icon, color: iconColor ?? AppColors.iconWhite, size: 20),
      title: Text(
        title,
        style: AppTextStyles.font13W600White(context),
      ),
      trailing: const AppArrowIcon(),
    );
  }

  Widget _buildSocialIcon(
    IconData icon, {
    required Color color,
    required VoidCallback onTap,
    double size = 24,
  }) {
    return InkWell(
      onTap: onTap,
      child: Icon(icon, color: color, size: size),
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
