// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/features/settings/presentation/widgets/settings_tile_widget.dart';
import 'package:sana/features/settings/presentation/widgets/settings_title.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpOptionsSection extends StatelessWidget {
  const HelpOptionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsTitleSection(title: 'مساعدة'),
        const SizedBox(height: 12),
        SettingsTileWidget(
          icon: Icons.info_outline,
          title: 'الإبلاغ عن مشكلة',
          onTap: () => context.pushNamed(AppRoutes.report),
        ),
        SettingsTileWidget(
          icon: Icons.lightbulb_outline,
          title: 'اقتراحات للإضافة',

          onTap: () {
            context.pushNamed(
              AppRoutes.report,
              queryParameters: {'isSuggestion': 'true'},
            );
          },
        ),
        SettingsTileWidget(
          icon: Icons.share_outlined,
          title: 'شارك التطبيق',
          onTap: _shareApp,
        ),
        SettingsTileWidget(
          icon: Icons.star_outline,
          title: 'تقييم التطبيق',
          onTap: () => _launchPlayStore(context),
        ),
      ],
    );
  }

  Future<void> _launchPlayStore(BuildContext context) async {
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
