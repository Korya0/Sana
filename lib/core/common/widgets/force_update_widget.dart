// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sana/core/common/widgets/app_buttons.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

/// رابط ملف الإعدادات على GitHub
const String _configUrl =
    'https://raw.githubusercontent.com/Korya0/Sana/refs/heads/feature/enhancetoshare/config.json';

class ForceUpdateController extends StatefulWidget {
  final Widget child;

  const ForceUpdateController({super.key, required this.child});

  @override
  State<ForceUpdateController> createState() => _ForceUpdateControllerState();
}

class _ForceUpdateControllerState extends State<ForceUpdateController> {
  String currentVersion = "0.0.0";
  bool _bannerDismissed = false;
  Map<String, dynamic>? _configData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await Future.wait([_getCurrentVersion(), _fetchConfig()]);
  }

  Future<void> _getCurrentVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        currentVersion = info.version;
      });
    }
  }

  Future<void> _fetchConfig() async {
    print("DEBUG: Fetching config from $_configUrl");
    try {
      final dio = Dio();
      final response = await dio.get(
        _configUrl,
        options: Options(
          responseType: ResponseType.plain, // Ensure we see raw text
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {'Cache-Control': 'no-cache'}, // Try to bypass cache
        ),
      );

      print("DEBUG: Config Response Code: ${response.statusCode}");
      print("DEBUG: Config Body: ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data;
        if (mounted) {
          setState(() {
            _configData = data is String ? jsonDecode(data) : data;
            _isLoading = false;
          });
          print("DEBUG: Config Parsed: $_configData");
        }
      }
    } catch (e) {
      print('DEBUG: Error fetching config: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  bool _isVersionLessThan(String current, String latest) {
    print("DEBUG: Comparing Current($current) vs Latest($latest)");
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
    return Stack(children: [widget.child, _buildUpdateOverlay()]);
  }

  Widget _buildUpdateOverlay() {
    if (_isLoading || currentVersion == "0.0.0" || _configData == null) {
      return const SizedBox.shrink();
    }

    final String latestVersion =
        _configData!['latest_version']?.toString() ?? "1.0.0";
    final bool forceStop = _configData!['force_stop'] == true;
    final bool showBanner = _configData!['show_banner'] == true;
    final String? message = _configData!['message'];

    final bool isOld = _isVersionLessThan(currentVersion, latestVersion);

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
                      style: AppTextStyles.font16W500Whit(context).copyWith(
                        color: AppColors.white.withOpacity(0.7),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    AppSecondaryButton(
                      text: 'تحديث الآن',
                      onPressed: _launchURL,
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
              child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
            );
          },
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.secondaryBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.gold.withOpacity(0.3)),
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
                      padding: const EdgeInsets.symmetric(horizontal: 8),
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
                    onPressed: () => setState(() => _bannerDismissed = true),
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
  }

  Future<void> _launchURL() async {
    final url = Uri.parse(AppConstants.playStoreUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
