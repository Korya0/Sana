// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sana/core/common/widgets/app_buttons.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpdateController extends StatefulWidget {
  final Widget child;

  const ForceUpdateController({super.key, required this.child});

  @override
  State<ForceUpdateController> createState() => _ForceUpdateControllerState();
}

class _ForceUpdateControllerState extends State<ForceUpdateController> {
  String currentVersion = "0.0.0";
  bool _bannerDismissed = false;

  @override
  void initState() {
    super.initState();
    _getCurrentVersion();
  }

  Future<void> _getCurrentVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      currentVersion = info.version;
    });
  }

  bool _isUpdateRequired(String current, String latest) {
    try {
      final currentParts = current.split('.').map(int.parse).toList();
      final latestParts = latest.split('.').map(int.parse).toList();

      for (int i = 0; i < latestParts.length; i++) {
        final currentPart = i < currentParts.length ? currentParts[i] : 0;
        if (latestParts[i] > currentPart) return true;
        if (latestParts[i] < currentPart) return false;
      }
    } catch (e) {
      // Fallback to simple comparison if parsing fails
      return current != latest;
    }
    return false;
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
            if (!snapshot.hasData || currentVersion == "0.0.0") {
              return const SizedBox.shrink();
            }

            final data = snapshot.data!.data() as Map<String, dynamic>?;
            if (data == null) return const SizedBox.shrink();

            final String latestVersion =
                data['latest_version']?.toString() ?? "1.0.0";
            final bool forceStop = data['force_stop'] == true;
            final bool showBanner = data['show_banner'] == true;
            final String? message = data['message'];

            final bool isOld = _isUpdateRequired(currentVersion, latestVersion);

            if (!isOld) return const SizedBox.shrink();

            if (forceStop) {
              return WillPopScope(
                onWillPop: () async => false,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Material(
                    color: AppColors.scaffoldBackground.withOpacity(0.8),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: AppColors.gold.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.system_update_rounded,
                                color: AppColors.gold,
                                size: 64,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'تحديث جديد متاح',
                              style: AppTextStyles.font22W700Gold(context),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              message ??
                                  'يجب تحديث التطبيق للمتابعة والحصول على أحدث المميزات والتحسينات.',
                              style: AppTextStyles.font16W500Whit(context)
                                  .copyWith(
                                    color: AppColors.white.withOpacity(0.7),
                                    height: 1.5,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),
                            AppSecondaryButton(
                              text: 'تحديث الآن',
                              onPressed: () => _launchURL(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }

            if (showBanner && !_bannerDismissed) {
              return Positioned(
                bottom: 24,
                left: 16,
                right: 16,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutBack,
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 100 * (1 - value)),
                      child: Opacity(
                        opacity: value.clamp(0.0, 1.0),
                        child: child,
                      ),
                    );
                  },
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryBackground,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.gold.withOpacity(0.3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: AppColors.gold),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'تحديث جديد متوفر',
                              style: AppTextStyles.font14W600White(context),
                            ),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: _launchURL,
                            child: Text(
                              'تحديث',
                              style: AppTextStyles.font16W600Gold(context),
                            ),
                          ),
                          IconButton(
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(4),
                            onPressed: () =>
                                setState(() => _bannerDismissed = true),
                            icon: const Icon(
                              Icons.close,
                              size: 22,
                              color: AppColors.grey,
                            ),
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

  Future<void> _launchURL() async {
    final url = Uri.parse(AppConstants.playStoreUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
