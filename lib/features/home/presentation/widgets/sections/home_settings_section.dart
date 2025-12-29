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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            _buildQuickTile(
              context,
              icon: FlutterIslamicIcons.mosque,
              title: 'مواقيت الصلاة',
              onTap: () => context.pushNamed(AppRoutes.prayerSettings),
            ),
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
              title: 'شارك التطبيق',
              onTap: () => _shareApp(),
            ),
            _buildQuickTile(
              context,
              icon: Icons.star_outline,
              title: 'تقييم التطبيق',
              onTap: () => _launchPlayStore(),
            ),
            const SizedBox(height: 16),
            const SmartSupportCard(),
            const SizedBox(height: 16),
          ],
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
      leading: Icon(icon, color: AppColors.gold.withOpacity(0.7), size: 20),
      title: Text(title, style: AppTextStyles.font14W600White(context)),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 12,
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
