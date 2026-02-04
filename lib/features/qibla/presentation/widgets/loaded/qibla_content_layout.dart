import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/qibla/presentation/widgets/compass/qibla_compass.dart';
import 'package:sana/features/qibla/presentation/widgets/hint/qibla_hint_message.dart';
import 'package:sana/features/qibla/presentation/widgets/qibla_header_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:js' as js;

/// Layout structure for Qibla content
class QiblaContentLayout extends StatelessWidget {
  final double? angleDifference;
  final double heading;
  final double qiblaDirection;
  final bool isNearQibla;
  final double distanceToKaaba;
  final double lat;
  final double lng;

  const QiblaContentLayout({
    super.key,
    required this.angleDifference,
    required this.heading,
    required this.qiblaDirection,
    required this.isNearQibla,
    required this.distanceToKaaba,
    required this.lat,
    required this.lng,
  });

  void _requestPermission() {
    js.context.callMethod('eval', [
      """
      if (typeof DeviceOrientationEvent !== 'undefined' && typeof DeviceOrientationEvent.requestPermission === 'function') {
        DeviceOrientationEvent.requestPermission()
          .then(permissionState => {
            if (permissionState === 'granted') {
              window.location.reload();
            }
          })
          .catch(err => alert('حدث خطأ أثناء طلب الإذن: ' + err));
      } else {
        alert('حساس البوصلة غير متوفر أو أن المتصفح لا يحتاج لإذن إضافي. تأكد من تفعيل الموقع والحساسات في إعدادات الهاتف.');
      }
      """,
    ]);
  }

  Future<void> _showOnMap() async {
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&origin=$lat,$lng&destination=21.4225,39.8262&travelmode=walking',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),

        // Hint message
        if (angleDifference != null)
          QiblaHintMessage(angleDifference: angleDifference!)
        else if (kIsWeb)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'إذا لم تتحرك البوصلة، يرجى الضغط على الزر أدناه لتفعيل الحساسات أو العرض على الخريطة',
              style: AppTextStyles.font14W500Grey(context),
              textAlign: TextAlign.center,
            ),
          )
        else
          const SizedBox.shrink(),

        const SizedBox(height: 20),

        // Compass
        Expanded(
          child: Center(
            child: QiblaCompass(
              heading: heading,
              qiblaDirection: qiblaDirection,
              activeColor: isNearQibla,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Buttons for Web Support
        if (kIsWeb) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _requestPermission,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.compass_calibration),
                    label: const Text('تشغيل البوصلة'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _showOnMap,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.gold,
                      side: const BorderSide(color: AppColors.gold),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.map),
                    label: const Text('عرض المسار'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],

        // Qibla info
        QiblaInfo(distance: distanceToKaaba, direction: qiblaDirection),

        const SizedBox(height: 40),
      ],
    );
  }
}
