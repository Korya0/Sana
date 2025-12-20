import 'package:flutter/material.dart';
import 'package:sana/core/common/widgets/common_sliver_app_bar.dart';
import 'package:sana/core/common/widgets/smart_support_card.dart';
import 'package:sana/core/constants/app_spacing.dart';
import 'package:sana/features/settings/presentation/widgets/help_options_section.dart';
import 'package:sana/features/settings/presentation/widgets/preferences_section.dart';
import 'package:sana/features/settings/presentation/widgets/social_media_links.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CommonSliverAppBar(title: 'الإعدادات'),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 16),

              // preferences
              const PreferencesSection(),
              const SizedBox(height: 24),

              // Contact Options
              const HelpOptionsSection(),
              const SizedBox(height: 24),

              const SizedBox(height: AppSpacing.betweenSections18),

              // heree
              const SmartSupportCard(),
              const SizedBox(height: 24),

              const SocialMediaLinks(),
              const SizedBox(height: 24),
            ]),
          ),
        ],
      ),
    );
  }
}
