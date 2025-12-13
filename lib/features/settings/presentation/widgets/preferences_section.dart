import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/features/settings/presentation/widgets/settings_tile_widget.dart';
import 'package:sana/features/settings/presentation/widgets/settings_title.dart';

class PreferencesSection extends StatelessWidget {
  const PreferencesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsTitleSection(title: 'التفضيلات'),
        const SizedBox(height: 12),
        SettingsTileWidget(
          icon: FlutterIslamicIcons.mosque,
          title: 'مواقيت الصلاة',
          onTap: () => context.pushNamed(AppRoutes.prayerSettings),
        ),
      ],
    );
  }
}
