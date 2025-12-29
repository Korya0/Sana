// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
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
          leading: const Icon(Icons.settings_outlined, color: AppColors.gold),
          title: Text(
            'الإعدادات والمساعدة',
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
            _buildSectionHeader(context, 'العبادة ومواقيت الصلاة'),
            _buildQuickTile(
              context,
              icon: FlutterIslamicIcons.mosque,
              title: 'إعدادات مواقيت الصلاة',
              onTap: () => context.pushNamed(AppRoutes.prayerSettings),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Divider(color: AppColors.grey, thickness: 0.2, height: 1),
            ),
            _buildSectionHeader(context, 'الدعم والمساعدة'),
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Divider(color: AppColors.grey, thickness: 0.2, height: 1),
            ),
            _buildSectionHeader(context, 'عن التطبيق'),
            _buildQuickTile(
              context,
              icon: Icons.share_outlined,
              title: 'شارك التطبيق مع غيرك',
              onTap: () => _shareApp(),
            ),
            _buildQuickTile(
              context,
              icon: Icons.star_outline,
              title: 'تقييم التطبيق على المتجر',
              onTap: () => _launchPlayStore(),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Divider(color: AppColors.grey, thickness: 0.2, height: 1),
            ),
            _buildSectionHeader(context, 'ساهم معنا'),
            const SizedBox(height: 8),
            const SmartSupportCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 4, right: 12),
        child: Text(
          title,
          style: AppTextStyles.font14W600Gold(
            context,
          ).copyWith(fontSize: 13, letterSpacing: 0.5),
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
      leading: Icon(icon, color: AppColors.gold.withOpacity(0.7), size: 18),
      title: Text(
        title,
        style: AppTextStyles.font14W600White(context).copyWith(fontSize: 13),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 10,
        color: AppColors.grey,
      ),
    );
  }

  Future<void> _launchPlayStore() async {
    const url = AppConstants.playStoreUrl;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _shareApp() async {
    const String shareMessage =
        '''
تطبيق ${AppConstants.appName} - رفيقك في الطاعات
"الدال على الخير كفاعله" 
حمّل التطبيق الآن:
${AppConstants.playStoreUrl}
''';

    await Share.share(shareMessage, subject: AppConstants.appName);
  }
}
