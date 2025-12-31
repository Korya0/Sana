// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/widgets/smart_support_card.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeSettingsSection extends StatelessWidget {
  const HomeSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          collapsedBackgroundColor: AppColors.secondaryBackground.withOpacity(
            0.5,
          ),
          backgroundColor: AppColors.secondaryBackground.withOpacity(0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'الإعدادات',
            style: AppTextStyles.font16W600White(context),
          ),
          trailing: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.grey,
          ),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          children: [
            // 1. Preferences Section
            _buildSectionHeader(context, 'التفضيلات'),
            _buildQuickTile(
              context,
              icon: FlutterIslamicIcons.mosque,
              title: 'إعدادات مواقيت الصلاة',
              onTap: () => context.pushNamed(AppRoutes.prayerSettings),
            ),
            _buildQuickTile(
              context,
              icon: Icons.favorite_border_rounded,
              title: 'المفضلة اليومية',
              onTap: () => context.pushNamed(AppRoutes.dailyContentFavorites),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Divider(color: AppColors.grey, thickness: 0.1, height: 16),
            ),

            // 2. Help Section
            _buildSectionHeader(context, 'المساعدة'),
            _buildQuickTile(
              context,
              icon: Icons.info_outline,
              title: 'الإبلاغ عن مشكلة',
              onTap: () => context.pushNamed(AppRoutes.report),
            ),
            _buildQuickTile(
              context,
              icon: Icons.lightbulb_outline,
              title: 'اقتراحات للإضافة',
              onTap: () => context.pushNamed(
                AppRoutes.report,
                queryParameters: {'isSuggestion': 'true'},
              ),
            ),
            _buildQuickTile(
              context,
              icon: Icons.share_outlined,
              title: 'شارك التطبيق مع غيرك',
              onTap: _shareApp,
            ),
            _buildQuickTile(
              context,
              icon: FontAwesomeIcons.googlePlay,
              title: 'تقييم التطبيق على المتجر',
              onTap: () => _launchURL(AppConstants.playStoreUrl),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Divider(color: AppColors.grey, thickness: 0.1, height: 16),
            ),

            // 3. Swap: Contribute with us Section (Now comes first)
            _buildSectionHeader(context, 'ساهم معنا'),
            const SizedBox(height: 8),
            const SmartSupportCard(),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Divider(color: AppColors.grey, thickness: 0.1, height: 16),
            ),

            // 4. Swap: Social Media section (Now at the bottom)
            Center(
              child: Text(
                'تابعنا على',
                style: AppTextStyles.font14W400WhiteHeight16(
                  context,
                ).copyWith(color: AppColors.grey, fontSize: 12),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialIcon(
                  FontAwesomeIcons.facebook,
                  color: const Color(0xFF1877F2),
                  onTap: () => _launchURL(AppConstants.facebookUrl),
                ),
                const SizedBox(width: 28),

                _buildSocialIcon(
                  FontAwesomeIcons.googlePlay,
                  color: const Color(0xFF34A853),
                  onTap: () => _launchURL(AppConstants.playStoreUrl),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 4, right: 12),
        child: Text(
          title,
          style: AppTextStyles.font14W600Gold(context).copyWith(
            fontSize: 12,
            // Re-highlight the header color (from grey to gold)
            color: AppColors.gold.withOpacity(0.85),
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      dense: true,
      visualDensity: VisualDensity.compact,
      leading: Icon(icon, color: AppColors.textWhite, size: 20),
      title: Text(
        title,
        style: AppTextStyles.font14W600White(context).copyWith(fontSize: 13),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 14,
        color: AppColors.textGrey,
      ),
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

  Future<void> _shareApp() async {
    const String shareMessage =
        '''
تطبيق ${AppConstants.appName} 
${AppConstants.playStoreUrl}
''';

    await Share.share(shareMessage, subject: AppConstants.appName);
  }
}
