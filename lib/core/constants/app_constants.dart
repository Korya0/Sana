class AppConstants {
  const AppConstants._();
  static const String appName = 'سَـنَـا';
  static const String ar = 'ar';
  static const String country = 'EG';
  static const String dateTimeFormat = 'yyyy-MM-dd / hh:mm a';
  static const String adminSecretPinHash =
      'e5ae4f1a218a6eb7820e7293af398fe0e8857046cc5e2f0c3569230c6cfce43a';
  static const String defaultVersion = '0.0.0+0';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const String defaultShareImageName = 'shared_content';

  // Animation Durations
  static const Duration animationFast200ms = Duration(milliseconds: 200);
  static const Duration animationNormal250ms = Duration(milliseconds: 250);
  static const Duration animationNormal300ms = Duration(milliseconds: 300);
  static const Duration animationSlow400ms = Duration(milliseconds: 400);
  static const Duration animationSlower500ms = Duration(milliseconds: 500);
  static const Duration animationSlower600ms = Duration(milliseconds: 600);
  static const Duration splashDelay1500ms = Duration(milliseconds: 1500);

  // Service Timeouts
  static const Duration hiveInitTimeout2s = Duration(seconds: 2);
  static const Duration locationTimeout5s = Duration(seconds: 5);
  static const Duration remoteConfigTimeout10s = Duration(seconds: 10);
  static const Duration remoteConfigFetchInterval12h = Duration(hours: 12);
}
