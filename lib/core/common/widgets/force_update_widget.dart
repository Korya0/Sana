// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sana/core/common/widgets/app_buttons.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_spacing.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';

class ForceUpdateController extends StatefulWidget {
  final Widget child;

  const ForceUpdateController({super.key, required this.child});

  @override
  State<ForceUpdateController> createState() => _ForceUpdateControllerState();
}

class _ForceUpdateControllerState extends State<ForceUpdateController> {
  int currentVersion = 0;

  @override
  void initState() {
    super.initState();
    _getCurrentVersion();
  }

  Future<void> _getCurrentVersion() async {
    final info = await PackageInfo.fromPlatform();
    currentVersion = int.tryParse(info.version.split('.').first) ?? 1;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,

        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('app_config')
              .doc('update')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || currentVersion == 0) {
              return const SizedBox.shrink();
            }

            final data = snapshot.data!.data() as Map<String, dynamic>?;

            if (data == null) return const SizedBox.shrink();

            final dynamic rawVersion = data['latest_version'] ?? 1;
            final int latestVersion = (rawVersion is int)
                ? rawVersion
                : (rawVersion is double ? rawVersion.toInt() : 1);

            final bool showBanner = data['show_banner'] == true;
            final bool forceStop = data['force_stop'] == true;
            final String? message = data['message'];

            final bool isOld = currentVersion < latestVersion;

            if (!isOld) return const SizedBox.shrink();

            if (forceStop) {
              return WillPopScope(
                onWillPop: () async => false,
                child: Material(
                  color: AppColors.scaffoldBackground.withAlpha(230),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.horizontalP18 * 2,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            ' يجب تحديث التطبيق للمتابعة',
                            style: AppTextStyles.font20W700White(context),
                          ),

                          if (message != null && message.isNotEmpty) ...[
                            SizedBox(height: AppSpacing.betweenSections18 * 2),
                            Text(
                              message,
                              style: AppTextStyles.font20W700White(context),
                            ),
                          ],
                          SizedBox(height: AppSpacing.betweenSections18 * 2),
                          AppSecondaryButton(
                            text: 'تحديث الآن',
                            textStyle: AppTextStyles.font16W600White(context),

                            onPressed: () async {
                              final url = Uri.parse(AppConstants.playStoreUrl);
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            if (showBanner) {
              return Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () async {
                    final url = Uri.parse(AppConstants.playStoreUrl);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
                  },
                  child: Material(
                    color: AppColors.secondaryBackground,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: Row(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'هناك تحديث جديد متاح',
                            style: AppTextStyles.font16W500Whit(context),
                          ),
                          Text(
                            'تحديث الآن',
                            style: AppTextStyles.font16W600Gold(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
