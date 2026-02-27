import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_links.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/home/presentation/widgets/show_financial_support_dialog.dart';
import 'package:share_plus/share_plus.dart';
import 'package:solar_icons/solar_icons.dart';
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
          collapsedBackgroundColor: AppColors.secondaryBackground.withValues(
            alpha: 0.5,
          ),
          backgroundColor: AppColors.secondaryBackground.withValues(alpha: 0.8),
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
            _buildSectionHeader(context, 'كن شريكاً في الأجر'),

            _buildQuickTile(
              context,
              icon: Icons.lightbulb_outline,
              title: 'اقتراح أو شكوى',
              onTap: () => context.pushNamed(
                AppRoutes.feedback,
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Divider(color: AppColors.grey, thickness: 0.1, height: 16),
            ),

            // 3. Support & Social Section
            GestureDetector(
              onLongPress: () async {
                await context.pushNamed(AppRoutes.developerDashboard);
              },
              child: _buildSectionHeader(context, 'معي شخصيا'),
            ),
            _buildQuickTile(
              context,
              icon: Icons.volunteer_activism_outlined,
              title: 'دعم مادي',
              onTap: () => showFinancialSupportDialog(context),
            ),
            _buildQuickTile(
              context,
              icon: FontAwesomeIcons.whatsapp,
              title: 'تواصل لأغراض العمل',
              onTap: () => _launchURL(AppLinks.whatsapp),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Divider(color: AppColors.grey, thickness: 0.1, height: 16),
            ),

            // 4. Share & Rate Section
            _buildSectionHeader(context, 'شارك وقيم'),
            _buildQuickTile(
              context,
              icon: SolarIconsOutline.heart,
              title: 'قيم التطبيق',
              onTap: () => _launchURL(AppLinks.playStore),
            ),
            _buildQuickTile(
              context,
              icon: SolarIconsOutline.share,
              title: 'مشاركة التطبيق',
              onTap: () => SharePlus.instance.share(
                ShareParams(
                  text: 'حمل تطبيق سَـنَـا الآن: ${AppLinks.playStore}',
                ),
              ),
            ),
            _buildQuickTile(
              context,
              icon: SolarIconsOutline.share,
              title: 'مشاركة للإيفون والويب',
              onTap: () => SharePlus.instance.share(
                ShareParams(
                  text: 'تصفح نسخة الويب من تطبيق سَـنَـا: ${AppLinks.webApp}',
                ),
              ),
            ),

            const SizedBox(height: 16),
            Center(
              child: Text(
                'تابع التطبيق علي',
                style: AppTextStyles.font14W400WhiteHeight16(
                  context,
                ).copyWith(color: AppColors.grey, fontSize: 12),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialIcon(
                  FontAwesomeIcons.facebook,
                  color: const Color(0xFF1877F2),
                  onTap: () => _launchURL(AppLinks.facebook),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'صدقة جاريه للمسلمين',
                style: AppTextStyles.font14W400WhiteHeight16(
                  context,
                ).copyWith(fontSize: 12),
              ),
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
            color: AppColors.gold.withValues(alpha: 0.85),
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
    Color? iconColor,
  }) {
    return ListTile(
      onTap: onTap,
      dense: true,
      visualDensity: VisualDensity.compact,
      leading: Icon(icon, color: iconColor ?? AppColors.textWhite, size: 20),
      title: Text(
        title,
        style: AppTextStyles.font14W600White(context).copyWith(fontSize: 13),
      ),
      trailing: const Icon(
        SolarIconsBold.altArrowLeft,
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
}
