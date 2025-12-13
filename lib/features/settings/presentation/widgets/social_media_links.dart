// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaLinks extends StatelessWidget {
  const SocialMediaLinks({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      children: [
        Text('تابعنا على ', style: AppTextStyles.font16W500Grey(context)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SocialIconButton(
              icon: FontAwesomeIcons.instagram,
              color: Colors.white,
              containerColor: Colors.pink,
              onTap: () => _launchUrl(AppConstants.instaUrl),
            ),
            SizedBox(width: (16)),
            _SocialIconButton(
              icon: FontAwesomeIcons.tiktok,
              containerColor: Colors.black,
              color: Colors.white,
              onTap: () => _launchUrl(AppConstants.tiktokUrl),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _SocialIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color containerColor;
  final VoidCallback onTap;

  const _SocialIconButton({
    required this.icon,
    required this.color,
    required this.containerColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all((8)),
        decoration: BoxDecoration(
          color: containerColor,
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(0.1), width: 1.5),
        ),
        child: FaIcon(icon, color: color, size: (18)),
      ),
    );
  }
}
